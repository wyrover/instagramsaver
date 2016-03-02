using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InstagramSaver.CommonTypes
{
    public class CommandLineMessages
    {
        public int Type { get; set; }
        public string Message { get; set; }
        public int Max { get; set; }
        public int Progress { get; set; }
        public string ErrorMessage { get; set; }
        public string PhotoLink { get; set; }
    }
}
