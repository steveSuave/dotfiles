\version "2.20.0"

upper = \relative c' {
  \clef treble
  \key c \major
  \time 4/4

  <c ees a>8
  <d f b>
  <ees g c>
  <f aes d>
  <g a ees'>4
  << \tuplet 3/2 {<d' f>8 <des e> <c ees>} \\ {fis,4} >>
  | <d fis a d>1
}

lower = \relative c' {
  \clef bass
  \key c \major
  \time 4/4

  g8 aes a b c4( <d, c'>) |
  <g, b'>2
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

