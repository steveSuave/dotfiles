\version "2.22.2"

\include "swing.ly"

\score {
  \tripletFeel 8 {
    \relative c'' {
      \clef treble
      \time 3/4
      \key c \major

      \tuplet 3/2 {bes8 f bes}
      \tuplet 3/2 {d bes d} f4 |
      r8
      fis \tuplet 3/2 {bes fis bes} d4 |
      r8. d,16 ees8. g16 bes8. d16 |
      ees4 d8. c16 b8. g16

    }
  }
  \layout { }
  \midi {
    \tempo 4 = 120
  }
}
