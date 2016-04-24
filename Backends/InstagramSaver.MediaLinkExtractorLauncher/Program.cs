using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HtmlAgilityPack;
using ImstagramSaver.Constants;
using InstagramSaver.CommonTypes;
using Newtonsoft.Json;
using HtmlAgilityPack;

namespace InstagramSaver.MediaLinkExtractorLauncher
{
    class Program
    {
        // html page content
        private static string _currentPageContent;

        //private static void Log(string msg)
        //{
        //    using (StreamWriter sw = File.CreateText("mle.txt"))
        //    {
        //        sw.WriteLine(String.Format("[{0}] {1}", DateTime.Now, msg));
        //    }
        //}

        static void Main(string[] args)
        {
            if (args.Length == 0)
            {
                Console.WriteLine("No page link.");
                return;
            }

            try
            {
                string photoPageLink = args[0];
                _currentPageContent = Downloader.Downloader.DownloadToString(Constants.StartUrl + photoPageLink);
                HtmlDocument htmlDocument = new HtmlDocument();
                htmlDocument.LoadHtml(_currentPageContent);
                HtmlNode img =
                    htmlDocument.DocumentNode.SelectSingleNode("//div[@class='mainimg_wrapper']//a//img[@src]");

                if (img != null)
                {
                    string imgLink = img.Attributes["src"].Value;
                    int endIndex = imgLink.IndexOf("ig_cache_key", StringComparison.Ordinal);
                    Console.WriteLine(endIndex > -1 ? imgLink.Substring(0, endIndex - 1) : imgLink);
                }
                else
                {
                    HtmlNode videoHtmlNode = htmlDocument.DocumentNode.SelectSingleNode("//div[@id='jquery_jplayer_1']");
                    if (videoHtmlNode != null)
                    {
                        string videoLink = videoHtmlNode.Attributes["data-m4v"].Value;
                        if (!String.IsNullOrEmpty(videoLink))
                        {
                            Console.WriteLine(videoLink);
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
