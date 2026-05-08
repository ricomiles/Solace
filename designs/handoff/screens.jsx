// Journal app screens — earth-tone pastel iOS journal
// Each component renders inside an IOSDevice frame at 320x694 (scaled-down)
// We render at native 402x874 inside the frame, but artboards scale them.

const T = {
  cream: '#F4ECE0',
  paper: '#FAF5EC',
  warm: '#EDE2D2',
  deep: '#E5D7C2',
  terra50: '#F7E8DC',
  terra100: '#EDD3BD',
  terra200: '#D4A88C',
  terra300: '#B8896C',
  terra400: '#8B7355',
  sage100: '#DCDDC7',
  sage200: '#B8BBA0',
  ink900: '#3A332B',
  ink700: '#5C5247',
  ink500: '#7C7062',
  ink300: '#A89A88',
  ink200: '#C9BCA8',
  hair: 'rgba(58, 51, 43, 0.08)',
  hairStrong: 'rgba(58, 51, 43, 0.14)',
  serif: "'Newsreader', 'Iowan Old Style', Georgia, serif",
  sans: "'Mulish', -apple-system, system-ui, sans-serif",
};

// ─────────────────────────────────────────────────────────────
// SAMPLE DATA
// ─────────────────────────────────────────────────────────────
const ENTRIES = [
  {
    id: 1, date: 'Wed, May 7', day: '07', month: 'MAY', year: '2026', mood: 'calm',
    title: 'Long walk by the canal',
    body: 'Took the long way home through the park. The light was that particular kind of gold you only get in early evening, when everything seems to slow down. I sat on the bench near the willow for a while and watched a heron stand absolutely still in the shallows.',
    tags: ['walking', 'reflection'], words: 247,
  },
  {
    id: 2, date: 'Tue, May 6', day: '06', month: 'MAY', year: '2026', mood: 'tender',
    title: 'A letter I never sent',
    body: 'Started writing to mom again, even though I know I won\'t send it. There\'s something about the act of putting words to paper that makes me feel close to her, like she\'s reading over my shoulder.',
    tags: ['family', 'memory'], words: 412,
  },
  {
    id: 3, date: 'Mon, May 5', day: '05', month: 'MAY', year: '2026', mood: 'restless',
    title: 'On not knowing',
    body: 'I keep wanting to have it figured out — the next move, the bigger picture, all of it. But maybe the not-knowing is the practice. Maybe sitting with the uncertainty is the work itself.',
    tags: ['work', 'doubt'], words: 189,
  },
  {
    id: 4, date: 'Sun, May 4', day: '04', month: 'MAY', year: '2026', mood: 'warm',
    title: 'Sunday slow morning',
    body: 'Coffee on the balcony. Read for two hours without checking my phone. A small act of resistance.',
    tags: ['rest', 'reading'], words: 98,
  },
  {
    id: 5, date: 'Fri, May 2', day: '02', month: 'MAY', year: '2026', mood: 'hopeful',
    title: 'New beginnings',
    body: 'Signed the lease today. The kitchen window faces east, which means I\'ll have morning light again for the first time in years.',
    tags: ['home', 'change'], words: 156,
  },
];

const MOODS = {
  calm:     { label: 'calm',     color: T.sage200,  dot: '#9CA888' },
  tender:   { label: 'tender',   color: '#E8C4B0',  dot: '#D8A892' },
  restless: { label: 'restless', color: '#D9B895',  dot: '#B89678' },
  warm:     { label: 'warm',     color: T.terra100, dot: T.terra300 },
  hopeful:  { label: 'hopeful',  color: '#E5D2A8',  dot: '#C9B080' },
};

// ─────────────────────────────────────────────────────────────
// Reusable bits
// ─────────────────────────────────────────────────────────────
function MoodDot({ mood, size = 8 }) {
  const m = MOODS[mood] || MOODS.calm;
  return <span style={{
    display: 'inline-block', width: size, height: size, borderRadius: '50%',
    background: m.dot, flexShrink: 0,
  }} />;
}

function StatusBar({ tint = T.ink900 }) {
  return (
    <div style={{
      display: 'flex', justifyContent: 'space-between', alignItems: 'center',
      padding: '18px 28px 0', fontFamily: T.sans, fontSize: 15, fontWeight: 600,
      color: tint, position: 'relative', zIndex: 5,
    }}>
      <span>9:41</span>
      <span style={{ display: 'flex', gap: 5, alignItems: 'center' }}>
        <svg width="16" height="10" viewBox="0 0 16 10"><rect x="0" y="6" width="2.5" height="4" rx="0.5" fill={tint}/><rect x="4" y="4" width="2.5" height="6" rx="0.5" fill={tint}/><rect x="8" y="2" width="2.5" height="8" rx="0.5" fill={tint}/><rect x="12" y="0" width="2.5" height="10" rx="0.5" fill={tint}/></svg>
        <svg width="22" height="11" viewBox="0 0 22 11"><rect x="0.5" y="0.5" width="19" height="10" rx="2.5" stroke={tint} strokeOpacity="0.4" fill="none"/><rect x="2" y="2" width="14" height="7" rx="1.5" fill={tint}/></svg>
      </span>
    </div>
  );
}

function HomeIndicator({ tint = T.ink900 }) {
  return (
    <div style={{ position: 'absolute', bottom: 8, left: 0, right: 0, display: 'flex', justifyContent: 'center', zIndex: 50 }}>
      <div style={{ width: 120, height: 4, borderRadius: 2, background: tint, opacity: 0.35 }} />
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// VARIATION A — Editorial home (large serif, paper feel)
// ─────────────────────────────────────────────────────────────
function HomeEditorial() {
  return (
    <div style={{
      width: 402, height: 874, background: T.paper, position: 'relative',
      fontFamily: T.sans, color: T.ink900, overflow: 'hidden',
    }}>
      <StatusBar />
      {/* Header */}
      <div style={{ padding: '42px 28px 0' }}>
        <div style={{ fontFamily: T.sans, fontSize: 12, letterSpacing: 2.4, color: T.ink500, textTransform: 'uppercase', fontWeight: 600 }}>
          May · Week 19
        </div>
        <h1 style={{
          fontFamily: T.serif, fontWeight: 400, fontSize: 44, lineHeight: 1.05,
          letterSpacing: -1, margin: '14px 0 8px', color: T.ink900,
        }}>
          Today, <em style={{ fontStyle: 'italic', color: T.terra300 }}>quietly.</em>
        </h1>
        <div style={{ fontFamily: T.serif, fontSize: 16, color: T.ink700, fontStyle: 'italic', lineHeight: 1.5 }}>
          You've written for 23 days in a row.
        </div>
      </div>

      {/* Today card */}
      <div style={{
        margin: '28px 20px 0', padding: '20px 22px',
        background: T.terra50, borderRadius: 18,
        position: 'relative', overflow: 'hidden',
      }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
          <div style={{ fontFamily: T.sans, fontSize: 11, letterSpacing: 1.8, color: T.terra400, textTransform: 'uppercase', fontWeight: 700 }}>
            Today's prompt
          </div>
          <div style={{ fontFamily: T.serif, fontStyle: 'italic', fontSize: 13, color: T.ink500 }}>05 / 12</div>
        </div>
        <div style={{ fontFamily: T.serif, fontSize: 22, lineHeight: 1.3, color: T.ink900, marginTop: 10, fontWeight: 400 }}>
          What softened you this week?
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginTop: 16 }}>
          <button style={{
            background: T.terra300, color: T.paper, border: 'none', padding: '10px 18px',
            borderRadius: 999, fontFamily: T.sans, fontSize: 14, fontWeight: 600, letterSpacing: -0.1,
          }}>Begin writing</button>
          <button style={{
            background: 'transparent', color: T.ink700, border: 'none', padding: '10px 12px',
            fontFamily: T.sans, fontSize: 14, fontWeight: 500,
          }}>Skip</button>
        </div>
      </div>

      {/* Section header */}
      <div style={{ padding: '34px 28px 16px', display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
        <div style={{ fontFamily: T.serif, fontSize: 22, fontWeight: 500, color: T.ink900 }}>Recent entries</div>
        <div style={{ fontFamily: T.sans, fontSize: 13, color: T.terra400, fontWeight: 600 }}>All</div>
      </div>

      {/* Entry list */}
      <div style={{ padding: '0 28px' }}>
        {ENTRIES.slice(0, 3).map((e, i) => (
          <div key={e.id} style={{
            display: 'flex', gap: 18, padding: '18px 0',
            borderTop: i === 0 ? `1px solid ${T.hairStrong}` : 'none',
            borderBottom: `1px solid ${T.hair}`,
          }}>
            <div style={{ width: 44, flexShrink: 0 }}>
              <div style={{ fontFamily: T.serif, fontSize: 28, fontWeight: 400, lineHeight: 1, color: T.ink900 }}>{e.day}</div>
              <div style={{ fontFamily: T.sans, fontSize: 10, letterSpacing: 1.4, color: T.ink500, textTransform: 'uppercase', fontWeight: 600, marginTop: 4 }}>{e.month}</div>
            </div>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ fontFamily: T.serif, fontSize: 17, fontWeight: 500, color: T.ink900, lineHeight: 1.25, marginBottom: 4 }}>
                {e.title}
              </div>
              <div style={{ fontFamily: T.sans, fontSize: 13, color: T.ink500, lineHeight: 1.45,
                display: '-webkit-box', WebkitLineClamp: 2, WebkitBoxOrient: 'vertical', overflow: 'hidden' }}>
                {e.body}
              </div>
              <div style={{ display: 'flex', gap: 10, alignItems: 'center', marginTop: 8 }}>
                <MoodDot mood={e.mood} size={6} />
                <span style={{ fontFamily: T.sans, fontSize: 11, color: T.ink500, letterSpacing: 0.3 }}>
                  {MOODS[e.mood].label} · {e.words} words
                </span>
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* FAB */}
      <button style={{
        position: 'absolute', right: 24, bottom: 36, width: 60, height: 60, borderRadius: 30,
        background: T.ink900, color: T.paper, border: 'none',
        boxShadow: '0 8px 24px rgba(58,51,43,0.28)',
        display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 40,
      }}>
        <svg width="22" height="22" viewBox="0 0 22 22" fill="none">
          <path d="M3 16.5L15.5 4l3.5 3.5L6.5 20H3v-3.5z" stroke={T.paper} strokeWidth="1.5" strokeLinejoin="round" fill="none"/>
        </svg>
      </button>

      <HomeIndicator />
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// VARIATION B — Card grid (clay tiles)
// ─────────────────────────────────────────────────────────────
function HomeCards() {
  return (
    <div style={{
      width: 402, height: 874, background: T.cream, position: 'relative',
      fontFamily: T.sans, color: T.ink900, overflow: 'hidden',
    }}>
      <StatusBar />
      {/* Top bar */}
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '46px 24px 0' }}>
        <div style={{
          width: 38, height: 38, borderRadius: 19, background: T.terra100,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          fontFamily: T.serif, fontSize: 16, fontWeight: 500, color: T.terra400, fontStyle: 'italic',
        }}>m</div>
        <div style={{ fontFamily: T.serif, fontSize: 18, fontWeight: 500, fontStyle: 'italic', color: T.ink900 }}>journal</div>
        <div style={{ width: 38, height: 38, borderRadius: 19, background: 'transparent', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <svg width="18" height="18" viewBox="0 0 18 18" fill="none" stroke={T.ink700} strokeWidth="1.5"><circle cx="8" cy="8" r="6"/><path d="M13 13l3 3"/></svg>
        </div>
      </div>

      {/* Greeting */}
      <div style={{ padding: '28px 24px 0' }}>
        <div style={{ fontFamily: T.sans, fontSize: 13, color: T.ink500, fontWeight: 500 }}>Wednesday, 7 May</div>
        <h1 style={{
          fontFamily: T.serif, fontWeight: 400, fontSize: 36, lineHeight: 1.1,
          letterSpacing: -0.6, margin: '6px 0 0',
        }}>
          Good evening, Maya.
        </h1>
      </div>

      {/* Streak strip */}
      <div style={{ display: 'flex', gap: 8, padding: '24px 24px 0', overflow: 'hidden' }}>
        {['M','T','W','T','F','S','S'].map((d, i) => {
          const filled = i < 5;
          return (
            <div key={i} style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6 }}>
              <div style={{
                width: 36, height: 44, borderRadius: 12,
                background: filled ? T.terra200 : T.warm,
                border: i === 2 ? `2px solid ${T.ink900}` : 'none',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                fontFamily: T.serif, fontSize: 15, fontWeight: 500,
                color: filled ? T.paper : T.ink300,
              }}>{filled ? '·' : ''}</div>
              <div style={{ fontFamily: T.sans, fontSize: 11, color: T.ink500, fontWeight: 600 }}>{d}</div>
            </div>
          );
        })}
      </div>

      {/* Two-tile grid */}
      <div style={{ padding: '24px 24px 0', display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
        <div style={{
          background: T.terra200, borderRadius: 22, padding: '18px 16px',
          height: 138, display: 'flex', flexDirection: 'column', justifyContent: 'space-between',
          color: T.paper,
        }}>
          <div style={{ fontFamily: T.sans, fontSize: 11, letterSpacing: 1.6, textTransform: 'uppercase', fontWeight: 700, opacity: 0.85 }}>Write now</div>
          <div>
            <div style={{ fontFamily: T.serif, fontSize: 22, lineHeight: 1.15, fontWeight: 400 }}>A blank page,<br/>waiting.</div>
            <div style={{ marginTop: 10, width: 32, height: 32, borderRadius: 16, background: 'rgba(255,255,255,0.22)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
              <svg width="14" height="14" viewBox="0 0 14 14" fill="none"><path d="M3 11L11 3M11 3H5M11 3v6" stroke={T.paper} strokeWidth="1.6" strokeLinecap="round"/></svg>
            </div>
          </div>
        </div>
        <div style={{
          background: T.sage100, borderRadius: 22, padding: '18px 16px',
          height: 138, display: 'flex', flexDirection: 'column', justifyContent: 'space-between',
          color: T.ink900,
        }}>
          <div style={{ fontFamily: T.sans, fontSize: 11, letterSpacing: 1.6, textTransform: 'uppercase', fontWeight: 700, color: T.ink700 }}>Prompt</div>
          <div>
            <div style={{ fontFamily: T.serif, fontSize: 17, lineHeight: 1.25, fontWeight: 400, fontStyle: 'italic' }}>
              "What did you almost say today?"
            </div>
          </div>
        </div>
      </div>

      {/* List */}
      <div style={{ padding: '28px 24px 16px', display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
        <div style={{ fontFamily: T.serif, fontSize: 19, fontWeight: 500 }}>This week</div>
        <div style={{ fontFamily: T.sans, fontSize: 12, color: T.ink500 }}>5 entries</div>
      </div>
      <div style={{ padding: '0 24px' }}>
        {ENTRIES.slice(0, 3).map((e) => (
          <div key={e.id} style={{
            display: 'flex', gap: 14, padding: '12px 14px',
            background: T.paper, borderRadius: 14, marginBottom: 8,
            alignItems: 'center',
          }}>
            <MoodDot mood={e.mood} size={8} />
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ fontFamily: T.serif, fontSize: 15, fontWeight: 500, color: T.ink900, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
                {e.title}
              </div>
              <div style={{ fontFamily: T.sans, fontSize: 11, color: T.ink500, marginTop: 2 }}>
                {e.date} · {e.words} words
              </div>
            </div>
            <svg width="12" height="12" viewBox="0 0 12 12" fill="none"><path d="M4 2l4 4-4 4" stroke={T.ink300} strokeWidth="1.5" strokeLinecap="round"/></svg>
          </div>
        ))}
      </div>

      <HomeIndicator />
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// VARIATION C — Timeline (vertical thread)
// ─────────────────────────────────────────────────────────────
function HomeTimeline() {
  return (
    <div style={{
      width: 402, height: 874, background: T.warm, position: 'relative',
      fontFamily: T.sans, color: T.ink900, overflow: 'hidden',
    }}>
      <StatusBar />
      <div style={{ padding: '42px 28px 18px', display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end' }}>
        <div>
          <div style={{ fontFamily: T.serif, fontSize: 13, fontStyle: 'italic', color: T.ink500 }}>—  the daybook  —</div>
          <h1 style={{ fontFamily: T.serif, fontSize: 38, fontWeight: 400, letterSpacing: -0.6, margin: '6px 0 0', lineHeight: 1 }}>
            May<span style={{ color: T.terra300 }}>.</span>
          </h1>
        </div>
        <div style={{ fontFamily: T.serif, fontSize: 13, fontStyle: 'italic', color: T.ink500, textAlign: 'right' }}>
          mmxxvi
        </div>
      </div>

      {/* Toggle */}
      <div style={{ padding: '0 28px 8px', display: 'flex', gap: 6 }}>
        {['Days','Weeks','Months'].map((t, i) => (
          <div key={t} style={{
            padding: '6px 14px', borderRadius: 999, fontFamily: T.sans, fontSize: 12, fontWeight: 600,
            background: i === 0 ? T.ink900 : 'transparent',
            color: i === 0 ? T.paper : T.ink500,
            border: i === 0 ? 'none' : `1px solid ${T.hairStrong}`,
          }}>{t}</div>
        ))}
      </div>

      {/* Timeline */}
      <div style={{ position: 'relative', padding: '20px 28px 40px' }}>
        {/* vertical line */}
        <div style={{ position: 'absolute', left: 56, top: 28, bottom: 40, width: 1, background: T.hairStrong }} />
        {ENTRIES.map((e, i) => (
          <div key={e.id} style={{ display: 'flex', gap: 14, marginBottom: 22, position: 'relative' }}>
            <div style={{ width: 36, textAlign: 'right', flexShrink: 0 }}>
              <div style={{ fontFamily: T.serif, fontSize: 22, fontWeight: 400, color: T.ink900, lineHeight: 1 }}>{e.day}</div>
              <div style={{ fontFamily: T.sans, fontSize: 9, letterSpacing: 1.2, color: T.ink500, textTransform: 'uppercase', marginTop: 2, fontWeight: 600 }}>{e.date.slice(0,3)}</div>
            </div>
            <div style={{
              width: 14, height: 14, borderRadius: 7, background: T.warm,
              border: `2px solid ${MOODS[e.mood].dot}`, flexShrink: 0, marginTop: 6, zIndex: 2,
            }} />
            <div style={{
              flex: 1, padding: '12px 16px', background: T.paper, borderRadius: 14,
              boxShadow: '0 1px 2px rgba(58,51,43,0.04)',
            }}>
              <div style={{ fontFamily: T.serif, fontSize: 16, fontWeight: 500, color: T.ink900, lineHeight: 1.25 }}>
                {e.title}
              </div>
              <div style={{ fontFamily: T.sans, fontSize: 12, color: T.ink500, lineHeight: 1.5, marginTop: 4,
                display: '-webkit-box', WebkitLineClamp: 2, WebkitBoxOrient: 'vertical', overflow: 'hidden' }}>
                {e.body}
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Tab bar */}
      <div style={{
        position: 'absolute', bottom: 24, left: 24, right: 24, height: 56,
        background: T.paper, borderRadius: 28, display: 'flex', alignItems: 'center', justifyContent: 'space-around',
        boxShadow: '0 4px 16px rgba(58,51,43,0.08)', zIndex: 30,
      }}>
        {[
          {n: 'Today', a: true},
          {n: 'Calendar'},
          {n: 'Write', primary: true},
          {n: 'Search'},
          {n: 'You'},
        ].map((t, i) => (
          <div key={i} style={{
            width: t.primary ? 44 : 'auto', height: t.primary ? 44 : 'auto',
            borderRadius: t.primary ? 22 : 0,
            background: t.primary ? T.ink900 : 'transparent',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            fontFamily: T.sans, fontSize: 12, fontWeight: t.a ? 700 : 500,
            color: t.primary ? T.paper : (t.a ? T.ink900 : T.ink500),
          }}>
            {t.primary ? <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M2 12L11 3l3 3-9 9H2v-3z" stroke={T.paper} strokeWidth="1.4" strokeLinejoin="round"/></svg> : t.n}
          </div>
        ))}
      </div>
      <HomeIndicator />
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// VARIATION D — Writing (paper, focused)
// ─────────────────────────────────────────────────────────────
function WriteFocus() {
  return (
    <div style={{
      width: 402, height: 874, background: T.paper, position: 'relative',
      fontFamily: T.serif, color: T.ink900, overflow: 'hidden',
    }}>
      <StatusBar />
      {/* minimal top bar */}
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '46px 24px 0' }}>
        <div style={{ fontFamily: T.sans, fontSize: 14, color: T.ink500, fontWeight: 500, display: 'flex', alignItems: 'center', gap: 6 }}>
          <svg width="14" height="14" viewBox="0 0 14 14" fill="none"><path d="M9 2L4 7l5 5" stroke={T.ink500} strokeWidth="1.5" strokeLinecap="round"/></svg>
          Close
        </div>
        <div style={{
          fontFamily: T.sans, fontSize: 11, color: T.terra400, fontWeight: 700,
          letterSpacing: 1.4, textTransform: 'uppercase', display: 'flex', alignItems: 'center', gap: 6,
        }}>
          <span style={{ width: 6, height: 6, borderRadius: 3, background: T.terra300, display: 'inline-block' }} />
          saved · 2m ago
        </div>
        <div style={{ fontFamily: T.sans, fontSize: 14, color: T.ink900, fontWeight: 600 }}>Done</div>
      </div>

      {/* Date / mood */}
      <div style={{ padding: '36px 32px 0' }}>
        <div style={{ fontFamily: T.sans, fontSize: 11, letterSpacing: 2, color: T.ink500, textTransform: 'uppercase', fontWeight: 700 }}>
          Wed · 7 May 2026 · evening
        </div>
        <input
          type="text"
          defaultValue="Long walk by the canal"
          style={{
            width: '100%', border: 'none', background: 'transparent',
            fontFamily: T.serif, fontWeight: 400, fontSize: 30, lineHeight: 1.15,
            letterSpacing: -0.5, color: T.ink900, padding: 0, margin: '14px 0 0', outline: 'none',
          }}
        />
        <div style={{ display: 'flex', gap: 8, marginTop: 14 }}>
          <div style={{
            display: 'flex', alignItems: 'center', gap: 6, padding: '6px 12px',
            background: T.sage100, borderRadius: 999,
            fontFamily: T.sans, fontSize: 12, color: T.ink700, fontWeight: 600,
          }}>
            <span style={{ width: 6, height: 6, borderRadius: 3, background: '#9CA888' }} /> calm
          </div>
          <div style={{
            padding: '6px 12px', borderRadius: 999,
            fontFamily: T.sans, fontSize: 12, color: T.ink500, fontWeight: 600,
            border: `1px dashed ${T.hairStrong}`,
          }}>+ tag</div>
        </div>
      </div>

      {/* Body */}
      <div style={{ padding: '24px 32px 0' }}>
        <p style={{
          fontFamily: T.serif, fontSize: 18, lineHeight: 1.65, color: T.ink700,
          margin: 0, letterSpacing: -0.1,
        }}>
          Took the long way home through the park. The light was that particular kind of gold you only get in early evening, when everything seems to slow down.
        </p>
        <p style={{ fontFamily: T.serif, fontSize: 18, lineHeight: 1.65, color: T.ink700, margin: '14px 0 0' }}>
          I sat on the bench near the willow for a while and watched a heron stand absolutely still in the shallows. It made me think about <span style={{ background: T.terra50, padding: '0 3px', borderRadius: 3 }}>patience</span> — the kind that isn't waiting for anything,&nbsp;
          <span style={{ display: 'inline-block', width: 1.5, height: 22, background: T.terra300, verticalAlign: 'middle', animation: 'blink 1s infinite' }} />
        </p>
      </div>

      {/* Footer toolbar */}
      <div style={{
        position: 'absolute', bottom: 32, left: 16, right: 16,
        padding: '10px 14px', background: T.cream, borderRadius: 999,
        display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        boxShadow: '0 2px 8px rgba(58,51,43,0.06)', zIndex: 30,
      }}>
        <div style={{ display: 'flex', gap: 6 }}>
          {[
            <path key="b" d="M4 2h5a3 3 0 010 6 3 3 0 010 6H4V2z" stroke={T.ink700} strokeWidth="1.5" fill="none"/>,
            <g key="i"><line x1="10" y1="2" x2="6" y2="14" stroke={T.ink700} strokeWidth="1.5"/><line x1="4" y1="2" x2="9" y2="2" stroke={T.ink700} strokeWidth="1.5"/><line x1="7" y1="14" x2="12" y2="14" stroke={T.ink700} strokeWidth="1.5"/></g>,
            <g key="q"><path d="M3 6c0-1 1-2 2-2 1 0 2 1 2 2 0 1-1 2-2 2v2M9 6c0-1 1-2 2-2 1 0 2 1 2 2 0 1-1 2-2 2v2" stroke={T.ink700} strokeWidth="1.4" fill="none" strokeLinecap="round"/></g>,
          ].map((p, i) => (
            <div key={i} style={{ width: 36, height: 36, borderRadius: 18, display: 'flex', alignItems: 'center', justifyContent: 'center', background: 'transparent' }}>
              <svg width="16" height="16" viewBox="0 0 16 16">{p}</svg>
            </div>
          ))}
        </div>
        <div style={{ fontFamily: T.sans, fontSize: 11, color: T.ink500, fontWeight: 600, letterSpacing: 0.4 }}>
          247 words
        </div>
        <div style={{
          width: 36, height: 36, borderRadius: 18, background: T.terra200,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>
          <svg width="14" height="14" viewBox="0 0 14 14" fill="none"><circle cx="7" cy="7" r="3" fill={T.paper}/><rect x="6" y="0" width="2" height="14" fill={T.paper}/></svg>
        </div>
      </div>
      <HomeIndicator />
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// VARIATION E — Writing with prompt (guided)
// ─────────────────────────────────────────────────────────────
function WritePrompted() {
  return (
    <div style={{
      width: 402, height: 874, background: T.cream, position: 'relative',
      fontFamily: T.serif, color: T.ink900, overflow: 'hidden',
    }}>
      <StatusBar />
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '46px 24px 0' }}>
        <div style={{ width: 32, height: 32, borderRadius: 16, background: T.warm, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <svg width="14" height="14" viewBox="0 0 14 14"><path d="M3 7h8M3 7l3-3M3 7l3 3" stroke={T.ink700} strokeWidth="1.5" fill="none" strokeLinecap="round"/></svg>
        </div>
        <div style={{ fontFamily: T.sans, fontSize: 13, color: T.ink500, fontWeight: 500 }}>Prompt 03 of 12</div>
        <div style={{ width: 32, height: 32 }} />
      </div>

      {/* Prompt card */}
      <div style={{ padding: '40px 28px 0' }}>
        <div style={{
          padding: '28px 24px', background: T.paper, borderRadius: 24,
          border: `1px solid ${T.hair}`,
        }}>
          <div style={{ fontFamily: T.sans, fontSize: 11, letterSpacing: 2, color: T.terra400, textTransform: 'uppercase', fontWeight: 700, marginBottom: 14 }}>
            Tonight's prompt
          </div>
          <div style={{ fontFamily: T.serif, fontSize: 26, fontWeight: 400, lineHeight: 1.25, letterSpacing: -0.3, color: T.ink900 }}>
            Describe a small kindness you noticed this week — one you didn't say thank you for.
          </div>
          <div style={{ marginTop: 18, display: 'flex', gap: 12, alignItems: 'center', fontFamily: T.sans, fontSize: 12, color: T.ink500, fontWeight: 500 }}>
            <span>~ 3 min read</span><span style={{ width: 3, height: 3, borderRadius: 2, background: T.ink300 }} /><span>by Mary Oliver</span>
          </div>
        </div>
      </div>

      {/* Writing area */}
      <div style={{ padding: '24px 28px 0' }}>
        <div style={{
          fontFamily: T.serif, fontStyle: 'italic', fontSize: 16, color: T.ink300,
        }}>
          Begin here…
        </div>
      </div>

      {/* Mood ring picker */}
      <div style={{ position: 'absolute', bottom: 168, left: 0, right: 0, padding: '0 28px' }}>
        <div style={{ fontFamily: T.sans, fontSize: 11, letterSpacing: 2, color: T.ink500, textTransform: 'uppercase', fontWeight: 700, marginBottom: 12 }}>
          How are you feeling?
        </div>
        <div style={{ display: 'flex', gap: 10, justifyContent: 'space-between' }}>
          {Object.entries(MOODS).map(([k, m], i) => (
            <div key={k} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6 }}>
              <div style={{
                width: 48, height: 48, borderRadius: 24, background: m.color,
                border: i === 0 ? `2px solid ${T.ink900}` : 'none',
                boxShadow: i === 0 ? `0 0 0 4px ${T.cream}` : 'none',
              }} />
              <div style={{ fontFamily: T.sans, fontSize: 11, color: T.ink700, fontWeight: 600 }}>{m.label}</div>
            </div>
          ))}
        </div>
      </div>

      {/* Bottom action */}
      <div style={{ position: 'absolute', bottom: 36, left: 24, right: 24 }}>
        <button style={{
          width: '100%', padding: '16px 20px', background: T.ink900, color: T.paper,
          border: 'none', borderRadius: 18, fontFamily: T.sans, fontSize: 15, fontWeight: 600,
          display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        }}>
          <span>Start writing</span>
          <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M3 8h10M9 4l4 4-4 4" stroke={T.paper} strokeWidth="1.6" strokeLinecap="round"/></svg>
        </button>
      </div>
      <HomeIndicator />
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// VARIATION F — Read entry (book-like)
// ─────────────────────────────────────────────────────────────
function ReadEntry() {
  return (
    <div style={{
      width: 402, height: 874, background: T.paper, position: 'relative',
      fontFamily: T.serif, color: T.ink900, overflow: 'hidden',
    }}>
      <StatusBar />
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '46px 20px 0' }}>
        <div style={{
          width: 36, height: 36, borderRadius: 18, background: T.cream,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>
          <svg width="14" height="14" viewBox="0 0 14 14" fill="none"><path d="M9 2L4 7l5 5" stroke={T.ink900} strokeWidth="1.5" strokeLinecap="round"/></svg>
        </div>
        <div style={{ fontFamily: T.sans, fontSize: 12, color: T.ink500, fontWeight: 500 }}>2 of 247</div>
        <div style={{ display: 'flex', gap: 8 }}>
          {['heart','more'].map((k, i) => (
            <div key={i} style={{ width: 36, height: 36, borderRadius: 18, background: T.cream, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
              <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
                {k === 'heart'
                  ? <path d="M7 12C2 9 1 6 1 4.5A2.5 2.5 0 014.5 2c1 0 2 .5 2.5 1.5C7.5 2.5 8.5 2 9.5 2A2.5 2.5 0 0113 4.5C13 6 12 9 7 12z" stroke={T.ink900} strokeWidth="1.4" fill="none"/>
                  : <g><circle cx="3" cy="7" r="1" fill={T.ink900}/><circle cx="7" cy="7" r="1" fill={T.ink900}/><circle cx="11" cy="7" r="1" fill={T.ink900}/></g>}
              </svg>
            </div>
          ))}
        </div>
      </div>

      {/* Header content */}
      <div style={{ padding: '36px 32px 0' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10, fontFamily: T.sans, fontSize: 11, letterSpacing: 1.6, textTransform: 'uppercase', color: T.terra400, fontWeight: 700 }}>
          Wed · 7 May
          <span style={{ width: 14, height: 1, background: T.terra200 }} />
          evening
        </div>
        <h1 style={{ fontFamily: T.serif, fontSize: 32, lineHeight: 1.15, fontWeight: 400, letterSpacing: -0.6, margin: '14px 0 18px', color: T.ink900 }}>
          Long walk by the canal
        </h1>
        <div style={{ display: 'flex', gap: 8, alignItems: 'center', fontFamily: T.sans, fontSize: 12, color: T.ink500, fontWeight: 500 }}>
          <MoodDot mood="calm" /> calm
          <span style={{ width: 3, height: 3, borderRadius: 2, background: T.ink300 }} />
          247 words
          <span style={{ width: 3, height: 3, borderRadius: 2, background: T.ink300 }} />
          18°c · clear
        </div>
      </div>

      {/* Decorative rule */}
      <div style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '24px 32px 0' }}>
        <div style={{ flex: 1, height: 1, background: T.hairStrong }} />
        <div style={{ width: 5, height: 5, borderRadius: 3, background: T.terra200 }} />
        <div style={{ flex: 1, height: 1, background: T.hairStrong }} />
      </div>

      {/* Body */}
      <div style={{ padding: '20px 32px 0' }}>
        <p style={{ fontFamily: T.serif, fontSize: 18, lineHeight: 1.7, color: T.ink700, margin: 0 }}>
          <span style={{
            float: 'left', fontFamily: T.serif, fontSize: 56, lineHeight: 0.85,
            color: T.terra300, marginRight: 8, marginTop: 4, fontWeight: 400,
          }}>T</span>
          ook the long way home through the park. The light was that particular kind of gold you only get in early evening, when everything seems to slow down.
        </p>
        <p style={{ fontFamily: T.serif, fontSize: 18, lineHeight: 1.7, color: T.ink700, margin: '16px 0 0' }}>
          I sat on the bench near the willow and watched a heron stand absolutely still in the shallows.
        </p>
        <blockquote style={{
          margin: '20px 0 0', padding: '0 0 0 16px',
          borderLeft: `2px solid ${T.terra200}`,
          fontFamily: T.serif, fontStyle: 'italic', fontSize: 18, lineHeight: 1.55, color: T.ink900,
        }}>
          "Patience that isn't waiting for anything."
        </blockquote>
      </div>
      <HomeIndicator />
    </div>
  );
}

Object.assign(window, { HomeEditorial, HomeCards, HomeTimeline, WriteFocus, WritePrompted, ReadEntry });
