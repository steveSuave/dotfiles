\version "2.20.0"

upper = \relative c'' {
  \clef treble
  \key d \major
  \time 4/4

  <cis fis>2
}

lower = \relative c {
  \clef bass
  \key c \major
  \time 4/4

  <a g'>2
}

\score {
  \new PianoStaff \with { instrumentName = "Piano" }
  <<
    \new Staff = "upper" \upper
    \new Staff = "lower" \lower
  >>
  \layout { }
  \midi { }
}
