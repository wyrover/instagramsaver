using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using InstagramSaver.CommonTypes;
using Newtonsoft.Json;

namespace InstagramSaver.PhotoDownloader
{
    class Program
    {
        static void Main(string[] args)
        {
            string link = args[0];
            string outputFile = args[1];
            try
            {
                Downloader.Downloader.DownloadToLocalJpeg(link, outputFile);
            }
            catch (Exception exception)
            {
                Console.WriteLine(exception.Message);
            }
        }
    }
}
