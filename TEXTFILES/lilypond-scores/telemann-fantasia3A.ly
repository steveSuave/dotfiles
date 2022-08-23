\version "2.20.0"

%% compile with: lilypond <filename>

#(set-global-staff-size 18)

\score {
  \new Staff {
    \set Staff.midiInstrument = "recorder"
    \transpose b a {
      \relative c'' {
	\clef treble
	\time 4/4
	\key b \minor

	b16 ^"Largo" d fis4. a,16 cis fis4.
	| g,16 b  e4( eis16)  fis fis,4 r

	| r16 ^"Vivace" d'32[ cis d16 b] g' b, cis g' d[ fis32 e fis16 d] a' cis, dis a'
	| e[ g32 fis g16 e] ais fis cis' e, d fis b d, e cis' fis, ais
	| b,( cis d) a-! gis d' fis, d' eis, cis'( bis cis) gis' cis, b' cis,
	| r a32[ gis a16 fis] d' fis, gis d' a[ cis32 b cis16 a] e' gis, ais e'
	| b[ d32 cis d16 b] eis cis gis' b, a cis fis a, b gis' cis, eis
	| fis, a cis fis r a cis, e dis fis b, b' cis, a' dis, fis
	| e, g b e r g b, d cis e a, a' b, g' cis, e
	| d, fis a d r fis d a' g, b'( a g) g, b' e,, g'
	| fis, a'( g fis) fis, a' d,, fis' g, b'( a g) g, b' e,, g'
	| fis, a'( g fis) fis, a' d,, fis' g, b' fis, a' e, g' d, fis'
	| cis e a,8 r16 g fis e fis a' b, d g, e' a, cis
	| fis, a' b, d g, e' a, cis d, fis' e, g' fis, a' g, b'
	| a, cis fis, d' g, e' a, cis d, cis'( d b) d, fis' d cis
	| e, cis'( d b) fis fis' d cis g cis( d b) e[ fis32 e d16 e]
	| fis, ais cis fis fis, b d fis fis, ais cis8 r4

	| d16 ^"Largo" fis a4. cis,16 e a4.
	| b,16 d g4( gis16) a cis, e a,8 r4
	| e'16 g! b4. d,16 fis b4.
	| c,16 e a4( ais16) b d, fis b,8 r4

	| r16 ^"Vivace" g32[ fis g16 e] c' e, fis c' g[ b32 a b16 g] d' fis, gis d'
	| a[ c32 b c16 a] dis b fis' a, g b e g, a fis' b, dis
	| e, e'( fis g) cis, g' b, g' a, cis e g r b a g
	| d, fis'( g fis) b, fis' a, fis' g, b d fis r b g dis
	| e( fis g) e cis( d e) cis ais( b cis) ais fis e' d cis
	| r d32[ cis d16 b] g' b, cis g' d[ fis32 e fis16 d] a' cis, dis a'
	| e[ g32 fis g16 e] ais fis cis' e, d fis b d, e cis' fis, ais
	| b,( cis d) b e, cis' fis, ais d, cis'( d b) e, cis' fis, ais
	| d, fis b a e gis cis b fis ais d cis g b e g
	| fis, ais'( b cis) d,, fis' b b, e, g'( fis e) fis, d' cis ais'
	| b, fis d' b fis' d b' fis d fis b,8 r4
	|
	\time 6/8
	\repeat volta 2 {
	  \partial 8 fis'8 ^"Allegro"
	  | fis e fis d cis d
	  | b ais b fis b d
	  | e, cis' e fis, d' cis
	  | d e cis b4 fis'8
	  | e,4 g'8 d,4 fis'8
	  | a, e' d cis d e
	  | fis,4 a'8 e,4 g'8
	  | d, fis' e fis g a
	  | g,4 b'8 e, g b
	  | fis,4 a'8 d, fis a
	  | e,4 g'8 cis, e g
	  | d, a' fis' fis, a d
	  | g, b e a, d cis
	  | d, cis'4 ~ cis4 d8
	  | g, cis4 ~ cis4 d8
	  | fis, cis'4 ~ cis4 d8
	  | b d g a, g' fis
	  | g, b e gis, e' d
	  | a cis e g, e' g,
	  | fis4 a'8 b, cis d
	  | g, cis d a d cis
	  | d,4. r8 r
	}

	\repeat volta 2 {
	  a''8
	  | a g a fis e fis
	  | d cis d a d fis
	  | g, e' g a, fis' e
	  | fis g e d4 fis8
	  | gis, b e e,4 d'8
	  | cis d b a4 b8
	  | ais cis fis fis,4 cis'8
	  | d e cis b4 fis'8
	  | g, b e fis, a d
	  | e,4 cis'8 g4 b8
	  | fis ais cis fis,4 e8
	  | d cis' b fis b ais
	  | b ais'4 ~ ais4 b8
	  | e, ais4 ~ ais4 b8
	  | d, ais'4 ~ ais4 b8
	  | c, e g b, e g
	  | ais, g' fis b, d fis
	  | e, cis' b fis4 ais'8
	  | b,4. r8 r
	}
      }
    }
  }
  \layout { }
  \midi { }
}
