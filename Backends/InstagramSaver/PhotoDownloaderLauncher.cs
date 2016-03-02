using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using InstagramSaver.CommonTypes;

namespace InstagramSaver
{
    public class PhotoDownloaderLauncher
    {
        public bool Running;
        public int Id { get; set; }

        private Process _subProcess = new Process();
        private int _index;
        private MainForm _mainForm;
        private string _exePath;

        public List<DownloadPair> DownloadPairs { get; set; }

        public void Launch(string exePath)
        {
            if (DownloadPairs.Count > 0)
            {
                _index = 0;
                _exePath = exePath;
                _subProcess.StartInfo.Arguments = DownloadPairs[_index].Url + " \"" + DownloadPairs[_index].FilePath + "\"";
                _subProcess.StartInfo.FileName = _exePath;
                _subProcess.Start();
                try
                {
                    _subProcess.BeginErrorReadLine();
                    _subProcess.BeginOutputReadLine();
                }
                catch (Exception)
                {
                    // ignored
                }
                Running = true;
            }
            else
            {
                Running = false;
            }
        }

        public PhotoDownloaderLauncher(MainForm mainForm)
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
            //_subProcess.BeginErrorReadLine();
            //_subProcess.BeginOutputReadLine();
            DownloadPairs = new List<DownloadPair>();
        }

        private void SubProcessOnOutputDataReceived(object sender, DataReceivedEventArgs dataReceivedEventArgs)
        {
            if (dataReceivedEventArgs != null)
            {
                _mainForm.AddError(dataReceivedEventArgs.Data);    
            }
        }

        private void SubProcessOnErrorDataReceived(object sender, DataReceivedEventArgs dataReceivedEventArgs)
        {
            if (dataReceivedEventArgs != null)
            {
                _mainForm.AddError(dataReceivedEventArgs.Data);
            }
        }

        private void SubProcessOnExited(object sender, EventArgs eventArgs)
        {
            Running = false;
            _index++;
            _mainForm.UpdateUiFromDownloader();
            if (_index < DownloadPairs.Count)
            {
                try
                {
                    _subProcess.Kill();
                }
                catch (Exception)
                {
                    // ignored
                }

                _subProcess.StartInfo.Arguments = DownloadPairs[_index].Url + " \"" + DownloadPairs[_index].FilePath + "\"";
                _subProcess.StartInfo.FileName = _exePath;
                _subProcess.Start();
                Running = true;
            }
        }
    }
}
