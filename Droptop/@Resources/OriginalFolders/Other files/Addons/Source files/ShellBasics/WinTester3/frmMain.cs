using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
using System.Threading;

namespace DroptopRainmeter
{
    /// <summary>
    /// Summary description for Form1.
    /// </summary>
    public class frmMain : ShellLib.ApplicationDesktopToolbar
    {
        private System.Windows.Forms.GroupBox grpEdge;
        private System.Windows.Forms.RadioButton rdoFloat;
        private System.Windows.Forms.RadioButton rdoRight;
        private System.Windows.Forms.RadioButton rdoLeft;
        private System.Windows.Forms.RadioButton rdoBottom;
        private System.Windows.Forms.RadioButton rdoTop;
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.Container components = null;

        public frmMain()
        {
            //
            // Required for Windows Form Designer support
            //
            InitializeComponent();

            //
            // TODO: Add any constructor code after InitializeComponent call
            //
        }

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                if (components != null)
                {
                    components.Dispose();
                }
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
            this.grpEdge = new System.Windows.Forms.GroupBox();
            this.rdoFloat = new System.Windows.Forms.RadioButton();
            this.rdoRight = new System.Windows.Forms.RadioButton();
            this.rdoLeft = new System.Windows.Forms.RadioButton();
            this.rdoBottom = new System.Windows.Forms.RadioButton();
            this.rdoTop = new System.Windows.Forms.RadioButton();
            this.SuspendLayout();
            // 
            // grpEdge
            // 
            this.grpEdge.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.grpEdge.Location = new System.Drawing.Point(10, 9);
            this.grpEdge.Name = "grpEdge";
            this.grpEdge.Size = new System.Drawing.Size(68, 2);
            this.grpEdge.TabIndex = 3;
            this.grpEdge.TabStop = false;
            this.grpEdge.Text = "Edge";
            // 
            // rdoFloat
            // 
            this.rdoFloat.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.rdoFloat.Location = new System.Drawing.Point(14, 102);
            this.rdoFloat.Name = "rdoFloat";
            this.rdoFloat.Size = new System.Drawing.Size(59, 18);
            this.rdoFloat.TabIndex = 9;
            this.rdoFloat.Text = "Float";
            this.rdoFloat.CheckedChanged += new System.EventHandler(this.rdo_CheckedChanged);
            // 
            // rdoRight
            // 
            this.rdoRight.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.rdoRight.Location = new System.Drawing.Point(14, 83);
            this.rdoRight.Name = "rdoRight";
            this.rdoRight.Size = new System.Drawing.Size(59, 19);
            this.rdoRight.TabIndex = 8;
            this.rdoRight.Text = "Right";
            this.rdoRight.CheckedChanged += new System.EventHandler(this.rdo_CheckedChanged);
            // 
            // rdoLeft
            // 
            this.rdoLeft.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.rdoLeft.Location = new System.Drawing.Point(14, 65);
            this.rdoLeft.Name = "rdoLeft";
            this.rdoLeft.Size = new System.Drawing.Size(59, 18);
            this.rdoLeft.TabIndex = 7;
            this.rdoLeft.Text = "Left";
            this.rdoLeft.CheckedChanged += new System.EventHandler(this.rdo_CheckedChanged);
            // 
            // rdoBottom
            // 
            this.rdoBottom.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.rdoBottom.Location = new System.Drawing.Point(14, 46);
            this.rdoBottom.Name = "rdoBottom";
            this.rdoBottom.Size = new System.Drawing.Size(59, 19);
            this.rdoBottom.TabIndex = 6;
            this.rdoBottom.Text = "Bottom";
            this.rdoBottom.CheckedChanged += new System.EventHandler(this.rdo_CheckedChanged);
            // 
            // rdoTop
            // 
            this.rdoTop.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.rdoTop.Location = new System.Drawing.Point(14, 28);
            this.rdoTop.Name = "rdoTop";
            this.rdoTop.Size = new System.Drawing.Size(59, 18);
            this.rdoTop.TabIndex = 5;
            this.rdoTop.Text = "Top";
            this.rdoTop.CheckedChanged += new System.EventHandler(this.rdo_CheckedChanged);
            // 
            // frmMain
            // 
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Inherit;
            this.ClientSize = new System.Drawing.Size(88, 20);
            this.Controls.Add(this.rdoFloat);
            this.Controls.Add(this.rdoRight);
            this.Controls.Add(this.rdoLeft);
            this.Controls.Add(this.rdoBottom);
            this.Controls.Add(this.rdoTop);
            this.Controls.Add(this.grpEdge);
            this.Name = "frmMain";
            this.Opacity = 0D;
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Text = "Droptop (Rainmeter)";
            this.Load += new System.EventHandler(this.frmMain_Load);
            this.ResumeLayout(false);

        }
        #endregion

        /// <summary>
        /// The main entry point for the application.
        /// </summary>

        [STAThread]
        public static void Main(string[] args)
        {
            // mutex checks if app is already open. If so, closes app.
            using (var mutex = new Mutex(false, "saebamini.com SingletonApp"))
            {
                bool isAnotherInstanceOpen = !mutex.WaitOne(TimeSpan.Zero);
                if (isAnotherInstanceOpen)
                {
                    return;
                } else
                {
                    Application.Run(new frmMain());
                }
            }
        }
				
		private void frmMain_Load(object sender, System.EventArgs e)
		{
            // sets default option on open
            this.Edge = AppBarEdges.Top;
		}
				
		private void rdo_CheckedChanged(object sender, System.EventArgs e)
		{
			RadioButton rdo = sender as RadioButton;
			if (rdo.Checked)
			{
				switch (rdo.Text)
				{
					case "Bottom":
						this.Edge = AppBarEdges.Bottom;
						break;

					case "Top":
						this.Edge = AppBarEdges.Top;
						break;
					
					case "Left":
						this.Edge = AppBarEdges.Left;
						break;

					case "Right":
						this.Edge = AppBarEdges.Right;
						break;

					case "Float":
						this.Edge = AppBarEdges.Float;
						break;

				}
			}
		}
	
		
	}
}
