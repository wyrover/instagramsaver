using System.Net;

namespace InstagramSaver.Downloader
{
    public static class Downloader
    {
        public static string DownloadToString(string link)
        {
            using (WebClient webClient = new WebClient())
            {
                return webClient.DownloadString(link);
            }
        }

        public static void DownloadToLocalJpeg(string link, string outputFilePath)
        {
            using (WebClient webClient = new WebClient())
            {
                webClient.DownloadFile(link, outputFilePath);
            }
        }
    }
}
