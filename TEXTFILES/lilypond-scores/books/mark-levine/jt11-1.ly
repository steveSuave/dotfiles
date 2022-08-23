\version "2.22.2"

upper = \relative c' {
  \clef treble
  \key bes \major
  \time 4/4

  \repeat volta 2 {
    <d f bes>2 <bes f' g>
    | <ees g c> <a, ees' f>
    | <bes d f> <bes f' g>
    | <g bes ees> <a ees' f>
    | <d f bes> <d aes' bes>
    | <bes ees g> <bes c ges'>
  }
  \alternative {
    { <bes d f> < bes f' g> | <g bes ees> <a ees' f> }
    { <bes d f> <a c ees> | <f bes d>1 }
  }
  \bar "||"
  | <c' a'>
  | <c a'>
  | <b a'>
  | <b a'>
  | <bes g'>
  | <bes g'>
  | <a g'>
  | <a g'>
  \bar "||"
  | <d f bes>2 <bes f' g>
  | <ees g c> <a, ees' f>
  | <bes d f> <bes f' g>
  | <g bes ees> <a ees' f>
  | <d f bes> <d aes' bes>
  | <bes ees g> <bes c ges'>
  | <bes d f> <a c ees>
  | <f bes d>1
}

lower = \relative c {
  \clef bass
  \key bes \major
  \time 4/4

  \repeat volta 2 {
    bes,2 g'
    | c, f
    | bes, g'
    | c, f
    | bes bes,
    | ees ees
  }
  \alternative {
    { bes g' | c, f }
    { bes, g' | bes,1 }
  }
  \bar "||"
  | <d' fis>1
  | <d fis>1
  | <g, f'>
  | <g f'>
  | <c e>
  | <c e>
  | <f, ees'>
  | <f ees'>
  \bar "||"
  | bes,2 g'
  | c, f
  | bes, g'
  | c, f
  | bes bes,
  | ees ees
  | bes g'
  | bes,1

}

\score {
  \new PianoStaff \with { instrumentName = "Piano" }
  <<
    \new Staff = "upper" \upper
    \new Staff = "lower" \lower
  >>
  \layout { }
}

\score {
  \unfoldRepeats {
    \new PianoStaff \with { instrumentName = "Piano" }
    <<
      \new Staff = "upper" \upper
      \new Staff = "lower" \lower
    >>
  }
  \midi {
    \tempo 4 = 140
  }
}
