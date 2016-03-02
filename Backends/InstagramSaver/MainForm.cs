using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Windows.Forms;
using InstagramSaver.CommonTypes;
using Newtonsoft.Json;

namespace InstagramSaver
{
    public partial class MainForm : Form
    {
        private PhotoPageLinkExtractorLauncher _photoLinkExtractorLauncher;
        private List<string> _mediaLinks = new List<string>();
        private List<string> _photoPageLinks = new List<string>();
        private string _lastConsoleOutput;
        private CommandLineMessages _commandLineMessages;
        private PhotoDownloaderLauncher[] _photoDownloaders = new PhotoDownloaderLauncher[16];
        private MediaLinkExtractorLauncher[] _mediaLinkExtractorLaunchers = new MediaLinkExtractorLauncher[16];
        private int _totalDownloadProgress;
        private int _mediaLinkExtractorDoneCounter = 0;
        private int _addedMediaLinkCounter = 0;

        public MainForm()
        {
            InitializeComponent();
        }

        public void AddError(string msg)
        {
            Invoke((MethodInvoker)delegate
            {
                textBox1.AppendText(msg + Environment.NewLine);
            });
        }

        public void UpdateAddedMediaLinkCounter()
        {
            _addedMediaLinkCounter++;

            Invoke((MethodInvoker)delegate
            {
                ProgressBar.Maximum = _mediaLinks.Count;
                ProgressLabel.Text = String.Format("Progres: {0}/{1}", _addedMediaLinkCounter, _mediaLinks.Count);
                if (_addedMediaLinkCounter < ProgressBar.Maximum)
                {
                    ProgressBar.Value = _addedMediaLinkCounter;
                }
            });
        }

        public void UpdateUiFromDownloader()
        {
            _totalDownloadProgress++;

            Invoke((MethodInvoker)delegate
            {
                ProgressBar.Maximum = _mediaLinks.Count;
                if (_totalDownloadProgress < ProgressBar.Maximum)
                {
                    ProgressLabel.Text = String.Format("Progres: {0}/{1}", _totalDownloadProgress, _mediaLinks.Count);
                    ProgressBar.Value = _totalDownloadProgress;
                }
            });
            if (_totalDownloadProgress == _mediaLinks.Count)
            {
                Invoke((MethodInvoker)EnableUi);
            }
        }

        public void AddToMediaLinks(List<string> links, int id)
        {
            _mediaLinks.AddRange(links);

            Invoke((MethodInvoker)delegate
            {
                ProgressLabel.Text = String.Format("Progres: {0}/{1}", _mediaLinks.Count, _photoPageLinks.Count);
                ProgressBar.Maximum = _mediaLinks.Count;
                ProgressBar.Value = _totalDownloadProgress;
            });

            _mediaLinkExtractorDoneCounter++;
            // todo: change this
            if (_mediaLinkExtractorDoneCounter == 4)
            {
                DownloadPhotos();
            }
        }

        public void UpdateUiFromSubProcess(string msg)
        {
            if (msg != _lastConsoleOutput)
            {
                if (!String.IsNullOrEmpty(msg))
                {
                    try
                    {
                        _commandLineMessages = JsonConvert.DeserializeObject<CommandLineMessages>(msg);
                        if (_commandLineMessages != null)
                        {
                            Invoke((MethodInvoker)delegate
                            {
                                StateLabel.Text = String.Format("State: {0}", _commandLineMessages.Message);
                                ProgressLabel.Text = String.Format("Progres: {0}/{1}", _commandLineMessages.Progress, _commandLineMessages.Max);
                            });
                            switch (_commandLineMessages.Type)
                            {
                                case 1:
                                    Invoke((MethodInvoker)delegate
                                    {
                                        ProgressBar.Maximum = _commandLineMessages.Max;
                                        ProgressBar.Value = _commandLineMessages.Progress;
                                    });
                                    break;
                                case 2:
                                    Invoke((MethodInvoker)delegate
                                    {
                                        textBox1.AppendText(_commandLineMessages.ErrorMessage + Environment.NewLine);
                                    });
                                    break;
                                case 3:
                                    Invoke((MethodInvoker)delegate
                                    {
                                        ProgressBar.Maximum = _commandLineMessages.Max;
                                        ProgressBar.Value = _commandLineMessages.Progress;
                                        _photoPageLinks.Add(_commandLineMessages.PhotoLink);
                                    });
                                    break;
                            }
                        }
                        _lastConsoleOutput = msg;
                    }
                    catch (Exception exception)
                    {
                        Invoke((MethodInvoker)delegate
                        {
                            textBox1.AppendText(exception.Message + Environment.NewLine);
                            textBox1.AppendText(msg + Environment.NewLine);
                        });
                    }
                }

            }
        }

        public void ExtractMediaLinks()
        {
            Invoke((MethodInvoker)delegate
            {
                StateLabel.Text = "State: Extracting image links";
            });

            // todo: change this
            int processCount = 4;

            List<List<string>> commandsList = new List<List<string>>(processCount);
            for (int i = 0; i < processCount; i++)
            {
                commandsList.Add(new List<string>());
            }
            _photoPageLinks = _photoPageLinks.Distinct().ToList();
            for (int i = 0; i < _photoPageLinks.Count; i++)
            {
                commandsList[i % processCount].Add(_photoPageLinks[i]);
            }
            for (int i = 0; i < commandsList.Count; i++)
            {
                string tempFilePath = Path.GetTempPath() + "\\instagramsaver_" + i.ToString() + ".txt";
                if (File.Exists(tempFilePath))
                {
                    File.Delete(tempFilePath);
                }
                File.WriteAllLines(tempFilePath, commandsList[i]);
            }

            for (int i = 0; i < processCount; i++)
            {
                string tempFilePath = "\"" + Path.GetTempPath() + "\\instagramsaver_" + i.ToString() + ".txt\"";
                _mediaLinkExtractorLaunchers[i].Launch(Path.GetDirectoryName(Application.ExecutablePath) + "\\InstagramSaver.MediaLinkExtractorLauncher.exe", tempFilePath);
            }
        }

        public void DownloadPhotos()
        {
            if (!Directory.Exists(OutputFolderEdit.Text + "\\" + ProfileNameEdit.Text))
            {
                Directory.CreateDirectory(OutputFolderEdit.Text + "\\" + ProfileNameEdit.Text);
            }
            Invoke((MethodInvoker)delegate
            {
                StateLabel.Text = "State: Downloading images";
            });

            _mediaLinks = _mediaLinks.Distinct().ToList();

            // todo: change this
            int processCount = 4;
            for (int i = 0; i < _mediaLinks.Count; i++)
            {
                string photoLink = _mediaLinks[i];
                string outputFileName = Path.GetFileName(photoLink.Replace("/", "\\"));
                _photoDownloaders[i % processCount].DownloadPairs.Add(new DownloadPair()
                {
                    FilePath = OutputFolderEdit.Text + "\\" + ProfileNameEdit.Text + "\\" + outputFileName,
                    Url = photoLink
                });
            }
            for (int i = 0; i < processCount; i++)
            {
                _photoDownloaders[i].Launch(Path.GetDirectoryName(Application.ExecutablePath) + "\\InstagramSaver.PhotoDownloader.exe");
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            _lastConsoleOutput = string.Empty;
            _mediaLinks.Clear();
            DisableUi();
            _photoLinkExtractorLauncher.Launch(Path.GetDirectoryName(Application.ExecutablePath) + "\\InstagramSaver.PhotoLinkExtractor.exe", ProfileNameEdit.Text);
        }

        private void DisableUi()
        {
            DownloadBtn.Enabled = false;
            StopBtn.Enabled = true;
            ProfileNameEdit.Enabled = false;
            OutputFolderEdit.Enabled = false;
            SelectOutputBtn.Enabled = false;
        }

        private void EnableUi()
        {
            DownloadBtn.Enabled = true;
            StopBtn.Enabled = false;
            ProfileNameEdit.Enabled = true;
            OutputFolderEdit.Enabled = true;
            SelectOutputBtn.Enabled = true;
            ProgressBar.Value = 0;
            ProgressLabel.Text = "Progress: 0/0";
            StateLabel.Text = "State:";
            TimeLabel.Text = "Time: 00:00:00";
        }


        private void StopBtn_Click(object sender, EventArgs e)
        {

        }

        private void MainForm_Load(object sender, EventArgs e)
        {
            _photoLinkExtractorLauncher = new PhotoPageLinkExtractorLauncher(this);
            for (int i = 0; i < _photoDownloaders.Length; i++)
            {
                _photoDownloaders[i] = new PhotoDownloaderLauncher(this)
                {
                    Id = i
                };
            }
            for (int i = 0; i < _mediaLinkExtractorLaunchers.Length; i++)
            {
                _mediaLinkExtractorLaunchers[i] = new MediaLinkExtractorLauncher(this)
                {
                    Id = i
                };
            }
        }

        private void MainForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            _photoLinkExtractorLauncher.Kill();
            //foreach (PhotoDownloaderLauncher photoDownloader in _photoDownloaders)
            //{
            //    photoDownloader.Kill();
            //}
        }
    }
}
