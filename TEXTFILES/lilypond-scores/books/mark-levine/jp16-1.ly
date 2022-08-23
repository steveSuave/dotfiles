\version "2.22.2"

\include "swing.ly"

upper = \relative c' {
  \clef treble
  \key c \major
  \time 4/4
  <c f a>4
  <b e gis b>8
  <a d g>~ <a d g>2
}

lower = \relative c {
  \clef bass
  \key c \major
  \time 4/4

  <d g>4
  f8 e~ e2
}

\score {
  \tripletFeel 8 {
    \new PianoStaff \with { instrumentName = "Piano" }
    <<
      \new Staff = "upper" \upper
      \new Staff = "lower" \lower
    >>
  }
  \layout { }
  \midi { }
}

