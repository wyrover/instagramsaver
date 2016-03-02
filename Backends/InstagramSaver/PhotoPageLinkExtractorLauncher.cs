using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InstagramSaver
{
    public class PhotoPageLinkExtractorLauncher
    {
        public bool Running;

        private Process _subProcess = new Process();
        private MainForm _mainForm;

        public void Launch(string exePath, string arguments)
        {
            _subProcess.StartInfo.Arguments = arguments;
            _subProcess.StartInfo.FileName = exePath;
            _subProcess.Start();
            _subProcess.BeginErrorReadLine();
            _subProcess.BeginOutputReadLine();
            Running = true;
        }

        public void Kill()
        {
            try
            {
                _subProcess.Kill();
            }
            catch (Exception)
            {
                // ignored
            }
        }

        public PhotoPageLinkExtractorLauncher(MainForm mainForm)
        {
            _mainForm = mainForm;
            Running = false;
            _subProcess.StartInfo.CreateNoWindow = true;
            _subProcess.EnableRaisingEvents = true;
            _subProcess.StartInfo.UseShellExecute = false;
            _subProcess.StartInfo.RedirectStandardError = true;
            _subProcess.StartInfo.RedirectStandardInput = true;
            _subProcess.StartInfo.RedirectStandardOutput = true;
            _subProcess.ErrorDataReceived += SubProcessOnErrorDataReceived;
            _subProcess.OutputDataReceived += SubProcessOnOutputDataReceived;
            _subProcess.Exited += SubProcessOnExited;
            //_subProcess.BeginErrorReadLine();
            //_subProcess.BeginOutputReadLine();
        }

        private void SubProcessOnExited(object sender, EventArgs eventArgs)
        {
            Running = false;
            _mainForm.ExtractMediaLinks();
        }

        private void SubProcessOnOutputDataReceived(object sender, DataReceivedEventArgs dataReceivedEventArgs)
        {
            if (dataReceivedEventArgs != null)
            {
                _mainForm.UpdateUiFromSubProcess(dataReceivedEventArgs.Data);
            }
        }

        private void SubProcessOnErrorDataReceived(object sender, DataReceivedEventArgs dataReceivedEventArgs)
        {
            if (dataReceivedEventArgs != null)
            {
                _mainForm.UpdateUiFromSubProcess(dataReceivedEventArgs.Data);
            }
        }
    }
}
