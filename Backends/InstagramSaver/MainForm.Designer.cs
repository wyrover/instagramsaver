namespace InstagramSaver
{
    partial class MainForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.DownloadBtn = new System.Windows.Forms.Button();
            this.ProfileNameEdit = new System.Windows.Forms.TextBox();
            this.OutputFolderEdit = new System.Windows.Forms.TextBox();
            this.ProgressBar = new System.Windows.Forms.ProgressBar();
            this.StateLabel = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.ToolBar = new System.Windows.Forms.Panel();
            this.StopBtn = new System.Windows.Forms.Button();
            this.ProfilePanel = new System.Windows.Forms.Panel();
            this.label2 = new System.Windows.Forms.Label();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.TimeLabel = new System.Windows.Forms.Label();
            this.ProgressLabel = new System.Windows.Forms.Label();
            this.SelectOutputBtn = new System.Windows.Forms.Button();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.ToolBar.SuspendLayout();
            this.ProfilePanel.SuspendLayout();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // DownloadBtn
            // 
            this.DownloadBtn.Dock = System.Windows.Forms.DockStyle.Left;
            this.DownloadBtn.Location = new System.Drawing.Point(247, 0);
            this.DownloadBtn.Name = "DownloadBtn";
            this.DownloadBtn.Size = new System.Drawing.Size(75, 60);
            this.DownloadBtn.TabIndex = 0;
            this.DownloadBtn.Text = "Download";
            this.DownloadBtn.UseVisualStyleBackColor = true;
            this.DownloadBtn.Click += new System.EventHandler(this.button1_Click);
            // 
            // ProfileNameEdit
            // 
            this.ProfileNameEdit.Location = new System.Drawing.Point(86, 19);
            this.ProfileNameEdit.Name = "ProfileNameEdit";
            this.ProfileNameEdit.Size = new System.Drawing.Size(155, 20);
            this.ProfileNameEdit.TabIndex = 1;
            this.ProfileNameEdit.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // OutputFolderEdit
            // 
            this.OutputFolderEdit.Location = new System.Drawing.Point(86, 66);
            this.OutputFolderEdit.Name = "OutputFolderEdit";
            this.OutputFolderEdit.Size = new System.Drawing.Size(458, 20);
            this.OutputFolderEdit.TabIndex = 3;
            this.OutputFolderEdit.Text = "C:\\InstagramSaver\\";
            // 
            // ProgressBar
            // 
            this.ProgressBar.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.ProgressBar.Location = new System.Drawing.Point(3, 102);
            this.ProgressBar.Name = "ProgressBar";
            this.ProgressBar.Size = new System.Drawing.Size(607, 24);
            this.ProgressBar.TabIndex = 4;
            // 
            // StateLabel
            // 
            this.StateLabel.AutoSize = true;
            this.StateLabel.Location = new System.Drawing.Point(9, 19);
            this.StateLabel.Name = "StateLabel";
            this.StateLabel.Size = new System.Drawing.Size(35, 13);
            this.StateLabel.TabIndex = 5;
            this.StateLabel.Text = "State:";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 22);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(68, 13);
            this.label1.TabIndex = 6;
            this.label1.Text = "Profile name:";
            // 
            // ToolBar
            // 
            this.ToolBar.Controls.Add(this.StopBtn);
            this.ToolBar.Controls.Add(this.DownloadBtn);
            this.ToolBar.Controls.Add(this.ProfilePanel);
            this.ToolBar.Dock = System.Windows.Forms.DockStyle.Top;
            this.ToolBar.Location = new System.Drawing.Point(0, 0);
            this.ToolBar.Name = "ToolBar";
            this.ToolBar.Size = new System.Drawing.Size(637, 60);
            this.ToolBar.TabIndex = 7;
            // 
            // StopBtn
            // 
            this.StopBtn.Dock = System.Windows.Forms.DockStyle.Left;
            this.StopBtn.Location = new System.Drawing.Point(322, 0);
            this.StopBtn.Name = "StopBtn";
            this.StopBtn.Size = new System.Drawing.Size(75, 60);
            this.StopBtn.TabIndex = 8;
            this.StopBtn.Text = "Stop";
            this.StopBtn.UseVisualStyleBackColor = true;
            this.StopBtn.Click += new System.EventHandler(this.StopBtn_Click);
            // 
            // ProfilePanel
            // 
            this.ProfilePanel.Controls.Add(this.ProfileNameEdit);
            this.ProfilePanel.Controls.Add(this.label1);
            this.ProfilePanel.Dock = System.Windows.Forms.DockStyle.Left;
            this.ProfilePanel.Location = new System.Drawing.Point(0, 0);
            this.ProfilePanel.Name = "ProfilePanel";
            this.ProfilePanel.Size = new System.Drawing.Size(247, 60);
            this.ProfilePanel.TabIndex = 7;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(9, 69);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(71, 13);
            this.label2.TabIndex = 8;
            this.label2.Text = "Output folder:";
            // 
            // groupBox1
            // 
            this.groupBox1.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.groupBox1.Controls.Add(this.TimeLabel);
            this.groupBox1.Controls.Add(this.ProgressLabel);
            this.groupBox1.Controls.Add(this.ProgressBar);
            this.groupBox1.Controls.Add(this.StateLabel);
            this.groupBox1.Location = new System.Drawing.Point(12, 92);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(613, 129);
            this.groupBox1.TabIndex = 9;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Progress";
            // 
            // TimeLabel
            // 
            this.TimeLabel.AutoSize = true;
            this.TimeLabel.Location = new System.Drawing.Point(9, 86);
            this.TimeLabel.Name = "TimeLabel";
            this.TimeLabel.Size = new System.Drawing.Size(78, 13);
            this.TimeLabel.TabIndex = 8;
            this.TimeLabel.Text = "Time: 00:00:00";
            // 
            // ProgressLabel
            // 
            this.ProgressLabel.AutoSize = true;
            this.ProgressLabel.Location = new System.Drawing.Point(9, 61);
            this.ProgressLabel.Name = "ProgressLabel";
            this.ProgressLabel.Size = new System.Drawing.Size(71, 13);
            this.ProgressLabel.TabIndex = 7;
            this.ProgressLabel.Text = "Progress: 0/0";
            // 
            // SelectOutputBtn
            // 
            this.SelectOutputBtn.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.SelectOutputBtn.Location = new System.Drawing.Point(550, 66);
            this.SelectOutputBtn.Name = "SelectOutputBtn";
            this.SelectOutputBtn.Size = new System.Drawing.Size(75, 20);
            this.SelectOutputBtn.TabIndex = 10;
            this.SelectOutputBtn.Text = "Select";
            this.SelectOutputBtn.UseVisualStyleBackColor = true;
            // 
            // textBox1
            // 
            this.textBox1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.textBox1.Location = new System.Drawing.Point(12, 224);
            this.textBox1.Multiline = true;
            this.textBox1.Name = "textBox1";
            this.textBox1.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.textBox1.Size = new System.Drawing.Size(610, 202);
            this.textBox1.TabIndex = 11;
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(637, 438);
            this.Controls.Add(this.textBox1);
            this.Controls.Add(this.SelectOutputBtn);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.ToolBar);
            this.Controls.Add(this.OutputFolderEdit);
            this.Name = "MainForm";
            this.Text = "Form1";
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.MainForm_FormClosed);
            this.Load += new System.EventHandler(this.MainForm_Load);
            this.ToolBar.ResumeLayout(false);
            this.ProfilePanel.ResumeLayout(false);
            this.ProfilePanel.PerformLayout();
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button DownloadBtn;
        private System.Windows.Forms.TextBox ProfileNameEdit;
        private System.Windows.Forms.TextBox OutputFolderEdit;
        private System.Windows.Forms.ProgressBar ProgressBar;
        private System.Windows.Forms.Label StateLabel;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Panel ToolBar;
        private System.Windows.Forms.Button StopBtn;
        private System.Windows.Forms.Panel ProfilePanel;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.Label TimeLabel;
        private System.Windows.Forms.Label ProgressLabel;
        private System.Windows.Forms.Button SelectOutputBtn;
        private System.Windows.Forms.TextBox textBox1;
    }
}

