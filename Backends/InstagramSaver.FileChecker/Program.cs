using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MediaInfoLib;

namespace InstagramSaver.FileChecker
{
    class Program
    {
        static void Main(string[] args)
        {
            if (args.Length == 1)
            {
                string filePath = args[0];
                if (!File.Exists(filePath))
                {
                    Environment.Exit(1);
                    return;
                }
                MediaInfo mediaInfo = new MediaInfo();
                mediaInfo.Open(filePath);
                int imgCount = mediaInfo.Count_Get(StreamKind.Image);
                int videoCount = mediaInfo.Count_Get(StreamKind.Video);
                Console.WriteLine(String.Format("Image count: {0}", imgCount));
                Console.WriteLine(String.Format("Video count: {0}", videoCount));
                if (imgCount > 0 || videoCount > 0)
                {
                    Environment.Exit(0);
                }
                else
                {
                    Environment.Exit(1);
                }
            }
            else
            {
                Environment.Exit(1);
            }
        }
    }
}
