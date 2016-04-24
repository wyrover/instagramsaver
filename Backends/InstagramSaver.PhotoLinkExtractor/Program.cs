using System;
using System.Collections.Generic;
using System.IO;
using System.Runtime.Remoting.Messaging;
using HtmlAgilityPack;
using ImstagramSaver.Constants;
using InstagramSaver.CommonTypes;
using Newtonsoft.Json;

namespace InstagramSaver.PhotoLinkExtractor
{
    class Program
    {
        // start page url
        private static string _profilePageURl;

        // html page content
        private static string _currentPageContent;

        private static string _nextPageLink;

        //private static List<string> _photoPageLinks = new List<string>();

        private static string _profileName;

        //private static void Log(string msg)
        //{
        //    using (StreamWriter sw = File.CreateText("ppe.txt"))
        //    {
        //        sw.WriteLine(String.Format("[{0}] {1}", DateTime.Now, msg));
        //    }
        //}

        static void Main(string[] args)
        {
            if (args.Length == 0)
            {
                Console.WriteLine("No profile name");
                return;
            }
            try
            {
                _profileName = args[0];

                _profilePageURl = Constants.StartUrl + "/n/" + _profileName;

                // download first page
                _currentPageContent = Downloader.Downloader.DownloadToString(_profilePageURl);

                // load first page's content
                HtmlDocument htmlDocument = new HtmlDocument();
                htmlDocument.LoadHtml(_currentPageContent);
                // extract photo page links
                foreach (HtmlNode node in htmlDocument.DocumentNode.SelectNodes("//a[@class='mainimg']"))
                {
                    Console.WriteLine(node.GetAttributeValue("href", null));
                }

                // try to get the next page link
                var nextLinkNode = htmlDocument.DocumentNode.SelectNodes("//a[@rel='next']")[0];
                if (nextLinkNode != null)
                {
                    string nextLink = nextLinkNode.GetAttributeValue("href", null);
                    if (!String.IsNullOrEmpty(nextLink))
                    {
                        _nextPageLink = nextLink;
                        while (!String.IsNullOrEmpty(_nextPageLink))
                        {
                            //if (_photoPageLinks.Count >= 20)
                            //{
                            //    break;
                            //}
                            if (!_nextPageLink.StartsWith("http"))
                            {
                                _nextPageLink = Constants.StartUrl + _nextPageLink;
                            }

                            try
                            {
                                // download the page
                                _currentPageContent = Downloader.Downloader.DownloadToString(_nextPageLink);

                                // load page content
                                htmlDocument.LoadHtml(_currentPageContent);
                                // extract photo page links
                                foreach (HtmlNode node in htmlDocument.DocumentNode.SelectNodes("//a[@class='mainimg']"))
                                {
                                    Console.WriteLine(node.GetAttributeValue("href", null));
                                }
                            }
                            catch (Exception exception)
                            {
                                //Log(exception.Message);
                            }

                            _nextPageLink = null;
                            try
                            {
                                nextLinkNode = htmlDocument.DocumentNode.SelectNodes("//a[@rel='next']")[0];
                                if (nextLinkNode != null)
                                {
                                    _nextPageLink = nextLinkNode.GetAttributeValue("href", null);
                                }
                            }
                            catch (Exception exception)
                            {
                                //Log(exception.Message);
                            }
                        }
                    }
                }
            }
            catch (Exception exception)
            {
                //Log(exception.Message);
            }

        }
    }
}
