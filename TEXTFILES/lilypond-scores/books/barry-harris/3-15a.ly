\version "2.20.0"

upper = \relative c' {
  \clef treble
  \key c \major
  \time 4/4

  <g c e>4 <aes d f> <a e' g> <c ees fis b>| <b d fis a>2
}

lower = \relative c {
  \clef bass
  \key c \major
  \time 4/4

  a4 b c d | g2
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

