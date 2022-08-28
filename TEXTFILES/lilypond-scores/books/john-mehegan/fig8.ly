\version "2.22.2"

\include "swing.ly"

upper = \relative c' {
  \clef treble
  \key ees \major
  \time 4/4

  c'8 r aes f ees d b' bes~
  | bes r aes g f e ees c
  | a' r g f ees des d b'
  | bes r r4 r g8 a
  \bar "||"
  \key g \major
  | b g e4 r8 a16 g f ees' c cis
  | e c b a gis f e ees d e f g gis b c b
  | <b d>8 g d r r4 f8 ees
  | d c16 d b8 r r16 b d f a f g b
  \bar "||"
  \key ees \major
  | e c bes g d8 r \tuplet 3/2 {r c d} \tuplet 3/2 {ees f g}
  | a d,16 ees c8 ces16 ees bes8 r a16 bes c d
  | \tuplet 3/2 {ees8 f g} <a ees>8 <aes ees>~ <aes ees>4 \tuplet 3/2 {ees8 f g}
  | <a ees> <aes ees>~ <aes ees>4 r r8 bes16 aes
  | g ees~ ees ees~ ees4 r \tuplet 3/2 {d8 ees f}
  | g16 aes bes c des c bes aes g4 r8 c16 bes

}

lower = \relative c {
  \clef bass
  \key ees \major
  \time 4/4

  <f, ees'>2 <aes f'>
  | <g f'> <c e>
  | <f, ees'> <bes d>
  | <ees, d'> <d' bes'>
  \bar "||"
  \key g \major
  | <cis b'> <c  a'>
  | <b a'> <e gis>
  | <a, g'> <d f>
  | <g, f'> <g e'>
  \bar "||"
  \key ees \major
  | <g f'>1
  | <fis ees'>
  | <f ees'>
  | <bes d>
  | <ees, d'>2 <d c'>
  | <g f'> <c e>

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
  \midi {
    \tempo 4 = 120
  }
}
