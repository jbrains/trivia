VERSION 5.00
Begin VB.Form frmGameRunner 
   Caption         =   "Form1"
   ClientHeight    =   5535
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7830
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   ScaleHeight     =   5535
   ScaleWidth      =   7830
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txtOutp 
      BeginProperty Font 
         Name            =   "Comic Sans MS"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   5535
      Left            =   0
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   0
      Top             =   -30
      Width           =   7785
   End
End
Attribute VB_Name = "frmGameRunner"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private bNotAWinner As Boolean

Private Sub Form_Activate()
    Dim aGame As New clsGame
    Set aGame.tbOutPut = Me.txtOutp
   
    aGame.Add "Chet"
    aGame.Add "Pat"
    aGame.Add "Sue"
    
    Randomize
    
    Do
        aGame.Roll CInt(6 * Rnd)
        If CInt(9 * Rnd) = 7 Then
            bNotAWinner = aGame.WrongAnswer
        Else
            bNotAWinner = aGame.WasCorrectlyAnswered()
        End If
    
    Loop While bNotAWinner
End Sub

Private Sub txtOutp_Change()
    txtOutp.SelStart = Len(txtOutp.Text)
    txtOutp.SelLength = 0
End Sub
