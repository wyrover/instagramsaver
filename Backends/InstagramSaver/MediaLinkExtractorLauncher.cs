using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InstagramSaver
{
    public class MediaLinkExtractorLauncher
    {
        public bool Running;
        public int Id { get; set; }

        private List<string> _consoleOutputs = new List<string>();
        private Process _subProcess = new Process();
        private int _index;
        private MainForm _mainForm;
        private string _exePath;

        public void Launch(string exePath, string listFilePath)
        {
            _index = 0;
            _exePath = exePath;
            _subProcess.StartInfo.Arguments = listFilePath;
            _subProcess.StartInfo.FileName = _exePath;
            _subProcess.Start();
            _subProcess.BeginErrorReadLine();
            _subProcess.BeginOutputReadLine();
            Running = true;
        }

        public MediaLinkExtractorLauncher(MainForm mainForm)
        {
            _mainForm = mainForm;
            Running = false;
            _subProcess.StartInfo.CreateNoWindow = true;
            _subProcess.EnableRaisingEvents = true;
            _subProcess.StartInfo.UseShellExecute = false;
            _subProcess.StartInfo.RedirectStandardError = true;
            _subProcess.StartInfo.RedirectStandardInput = true;
            _subProcess.StartInfo.RedirectStandardOutput = true;
            _subProcess.Exited += SubProcessOnExited;
            _subProcess.ErrorDataReceived += SubProcessOnErrorDataReceived;
            _subProcess.OutputDataReceived += SubProcessOnOutputDataReceived;
        }

        private void SubProcessOnOutputDataReceived(object sender, DataReceivedEventArgs dataReceivedEventArgs)
        {
            if (dataReceivedEventArgs != null)
            {
                if (!String.IsNullOrEmpty(dataReceivedEventArgs.Data))
                {
                    _consoleOutputs.Add(dataReceivedEventArgs.Data);
                    _mainForm.UpdateAddedMediaLinkCounter();
                }
            }
        }

        private void SubProcessOnErrorDataReceived(object sender, DataReceivedEventArgs dataReceivedEventArgs)
        {
            if (dataReceivedEventArgs != null)
            {
                if (!String.IsNullOrEmpty(dataReceivedEventArgs.Data))
                {
                    _consoleOutputs.Add(dataReceivedEventArgs.Data);
                    _mainForm.UpdateAddedMediaLinkCounter();
                }
            }
        }

        private void SubProcessOnExited(object sender, EventArgs eventArgs)
        {
            _mainForm.AddToMediaLinks(_consoleOutputs, Id);
            Running = false;
        }
    }
}
