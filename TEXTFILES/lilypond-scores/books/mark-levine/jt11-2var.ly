\version "2.22.2"

%% I got rhythm 40's harmony

ApartRight = {
  <d f g bes>2 <bes d f aes>
  | <bes ees g> <bes cis e g>
  | <a c f> <b e g>
  | <g bes ees> <a d f>
  | <d f bes> <bes d aes'>
  | <bes ees g> <bes cis e g>
}

ApartLeft = {
  bes2 b
  | c cis
  | d <g, f'>
  | c <f, ees'>
  | bes d,
  | ees e
}

upper = \relative c' {
  \clef treble
  \key bes \major
  \time 4/4

  \repeat volta 2 \ApartRight
  \alternative {
    { <bes d f> <b e> | <g bes ees> <a d> }
    { <a d f> <a cis f> | <g c f>1 }
  }
  \bar "||"
  | <c e a>
  | <c e a>
  | <b e a>
  | <b e a>
  | <bes d g>
  | <bes d g>
  | <a d g>
  | <a cis g'>
  \bar "||"
  \ApartRight
  |<a d f> <a cis f>
  | <g c f>1
}

lower = \relative c {
  \clef bass
  \key bes \major
  \time 4/4

  \repeat volta 2 \ApartLeft
  \alternative {
    { f2 <g f'> | c <f, ees'> }
    { <f ees'> <f ees'> | <bes d>1 }
  }
  \bar "||"
  | <d fis>1
  | <d fis>1
  | <g, f'>
  | <g f'>
  | <c e>
  | <c e>
  | <f, ees'>
  | <f ees'>
  \bar "||"
  \ApartLeft
  | <f ees'> <f ees'>
  | <bes d>1
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
				% \new PianoStaff \with { instrumentName = "Piano" }
    <<
      \new Staff = "upper" \upper
      \new Staff = "lower" \lower
    >>
  }
  \midi {
    \tempo 4 = 140
  }
}
