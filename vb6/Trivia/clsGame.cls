VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsGame"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private cPlayers As New Collection
Private iaPlaces(1 To 6) As Integer
Private iaPurses(1 To 6) As Integer
Private baInPenaltyBox(1 To 6) As Boolean

Private cPopQuestions As New Collection
Private cScienceQuestions As New Collection
Private cSportsQuestions As New Collection
Private cRockQuestions As New Collection

Public tbOutPut As TextBox

Private iCurrentPlayer As Integer
Private bIsGettingOutOfPenaltyBox As Boolean

Public Sub Class_Initialize()
    iCurrentPlayer = 1
    For i = 1 To 50
        cPopQuestions.Add ("Pop Question " & i)
        cScienceQuestions.Add ("Science Question " & i)
        cSportsQuestions.Add ("Sports Question " & i)
        cRockQuestions.Add (CreateRockQuestion(i))
    Next
End Sub

Private Sub WriteLine(line As String)
    tbOutPut.Text = tbOutPut.Text & line & vbCrLf
End Sub

Public Function CreateRockQuestion(iNumber)
    CreateRockQuestion = "Rock Question " & iNumber
End Function

Public Function IsPlayable()
    IsPlayable = HowManyPlayers >= 2
End Function

Public Function HowManyPlayers()
    HowManyPlayers = cPlayers.Count
End Function

Public Function Add(sPlayerName)
    cPlayers.Add sPlayerName
    iaPlaces(HowManyPlayers) = 0
    iaPurses(HowManyPlayers) = 0
    baInPenaltyBox(HowManyPlayers) = False
    
    WriteLine sPlayerName & " was added"
    WriteLine "They are player number " & cPlayers.Count
        
    Add = True
End Function

Public Sub Roll(iRoll)
    WriteLine cPlayers(iCurrentPlayer) & " is the current player"
    WriteLine "They have rolled a " & iRoll
    If baInPenaltyBox(iCurrentPlayer) Then
        If Not iRoll Mod 2 = 0 Then
            bIsGettingOutOfPenaltyBox = True
            WriteLine cPlayers(iCurrentPlayer) & " is getting out of the penalty box"
            iaPlaces(iCurrentPlayer) = iaPlaces(iCurrentPlayer) + iRoll
            If iaPlaces(iCurrentPlayer) > 11 Then iaPlaces(iCurrentPlayer) = iaPlaces(iCurrentPlayer) - 12
            WriteLine cPlayers(iCurrentPlayer) & _
                               "'s new location is " & _
                               iaPlaces(iCurrentPlayer)
                               
            WriteLine "The category is " & CurrentCategory
            AskQuestion
        Else
            WriteLine cPlayers(iCurrentPlayer) & " is not getting out of the penalty box"
            bIsGettingOutOfPenaltyBox = False
        End If
    Else
        iaPlaces(iCurrentPlayer) = iaPlaces(iCurrentPlayer) + iRoll
        If iaPlaces(iCurrentPlayer) > 11 Then iaPlaces(iCurrentPlayer) = iaPlaces(iCurrentPlayer) - 12
                    WriteLine cPlayers(iCurrentPlayer) & _
                               "'s new location is " & _
                               iaPlaces(iCurrentPlayer)
                               
        WriteLine "The category is " & CurrentCategory
        AskQuestion
    End If
End Sub

Private Sub AskQuestion()
    If CurrentCategory = "Pop" Then
        WriteLine cPopQuestions.Item(1)
        cPopQuestions.Remove 1
    End If
    If CurrentCategory = "Science" Then
        WriteLine cScienceQuestions.Item(1)
        cPopQuestions.Remove 1
    End If
    If CurrentCategory = "Sports" Then
        WriteLine cSportsQuestions.Item(1)
        cPopQuestions.Remove 1
    End If
    If CurrentCategory = "Rock" Then
        WriteLine cRockQuestions.Item(1)
        cPopQuestions.Remove 1
    End If
End Sub

Private Function CurrentCategory()
    If iaPlaces(iCurrentPlayer) = 0 Then
        CurrentCategory = "Pop"
        Exit Function
    End If
    If iaPlaces(iCurrentPlayer) = 4 Then
        CurrentCategory = "Pop"
        Exit Function
    End If
    If iaPlaces(iCurrentPlayer) = 8 Then
        CurrentCategory = "Pop"
        Exit Function
    End If
    If iaPlaces(iCurrentPlayer) = 1 Then
        CurrentCategory = "Science"
        Exit Function
    End If
    If iaPlaces(iCurrentPlayer) = 5 Then
        CurrentCategory = "Science"
        Exit Function
    End If
    If iaPlaces(iCurrentPlayer) = 9 Then
        CurrentCategory = "Science"
        Exit Function
    End If
    If iaPlaces(iCurrentPlayer) = 2 Then
        CurrentCategory = "Sports"
        Exit Function
    End If
    If iaPlaces(iCurrentPlayer) = 6 Then
        CurrentCategory = "Sports"
        Exit Function
    End If
    If iaPlaces(iCurrentPlayer) = 10 Then
        CurrentCategory = "Sports"
        Exit Function
    End If
    CurrentCategory = "Rock"
End Function

Public Function WasCorrectlyAnswered()
    If baInPenaltyBox(iCurrentPlayer) Then
        If bIsGettingOutOfPenaltyBox Then
            WriteLine "Answer was correct!!!!"
            iaPurses(iCurrentPlayer) = iaPurses(iCurrentPlayer) + 1
            WriteLine cPlayers(iCurrentPlayer) & _
                               " now has " & _
                               iaPurses(iCurrentPlayer) & _
                               " Gold Coins."
    
            winner = DidPlayerWin
            iCurrentPlayer = iCurrentPlayer + 1
            If iCurrentPlayer = cPlayers.Count + 1 Then iCurrentPlayer = 1
            WasCorrectlyAnswered = winner
            Exit Function
        Else
            iCurrentPlayer = iCurrentPlayer + 1
            If iCurrentPlayer = cPlayers.Count + 1 Then iCurrentPlayer = 1
            WasCorrectlyAnswered = True
            Exit Function
        End If
    Else
        WriteLine "Answer was corrent!!!!"
        iaPurses(iCurrentPlayer) = iaPurses(iCurrentPlayer) + 1
                    WriteLine cPlayers(iCurrentPlayer) & _
                               " now has " & _
                               iaPurses(iCurrentPlayer) & _
                               " Gold Coins."
    
        winner = DidPlayerWin
        iCurrentPlayer = iCurrentPlayer + 1
        If iCurrentPlayer = cPlayers.Count + 1 Then iCurrentPlayer = 1
        WasCorrectlyAnswered = winner
        Exit Function
    End If
End Function

Public Function WrongAnswer()
    WriteLine "Question was incorrectly answered"
    WriteLine cPlayers(iCurrentPlayer) + " was sent to the penalty box"
    baInPenaltyBox(iCurrentPlayer) = True
    iCurrentPlayer = iCurrentPlayer + 1
    If iCurrentPlayer = cPlayers.Count + 1 Then iCurrentPlayer = 1
    WrongAnswer = True
End Function

Private Function DidPlayerWin()
    DidPlayerWin = Not iaPurses(iCurrentPlayer) = 6
End Function
