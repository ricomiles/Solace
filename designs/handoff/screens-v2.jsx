// More journal screens — built on same T tokens (declared in screens.jsx, attached to window via Object.assign)
// We re-reference T via window.T... actually screens.jsx didn't expose T. Let's redeclare a local copy.
const T2 = {
  cream: '#F4ECE0', paper: '#FAF5EC', warm: '#EDE2D2', deep: '#E5D7C2',
  terra50: '#F7E8DC', terra100: '#EDD3BD', terra200: '#D4A88C', terra300: '#B8896C', terra400: '#8B7355',
  sage100: '#DCDDC7', sage200: '#B8BBA0',
  ink900: '#3A332B', ink700: '#5C5247', ink500: '#7C7062', ink300: '#A89A88', ink200: '#C9BCA8',
  hair: 'rgba(58, 51, 43, 0.08)', hairStrong: 'rgba(58, 51, 43, 0.14)',
  serif: "'Newsreader', 'Iowan Old Style', Georgia, serif",
  sans: "'Mulish', -apple-system, system-ui, sans-serif",
};

function MiniStatusBar({ tint = T2.ink900 }) {
  return (
    <div style={{
      display: 'flex', justifyContent: 'space-between', alignItems: 'center',
      padding: '18px 28px 0', fontFamily: T2.sans, fontSize: 15, fontWeight: 600,
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

function MiniHomeIndicator({ tint = T2.ink900 }) {
  return (
    <div style={{ position: 'absolute', bottom: 8, left: 0, right: 0, display: 'flex', justifyContent: 'center', zIndex: 50 }}>
      <div style={{ width: 120, height: 4, borderRadius: 2, background: tint, opacity: 0.35 }} />
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// CALENDAR — month grid w/ mood-colored days
// ─────────────────────────────────────────────────────────────
function CalendarMonth() {
  // 35 days: some written, some empty, varied moods
  const moodCols = ['#9CA888', '#D8A892', '#B89678', '#B8896C', '#C9B080'];
  const days = Array.from({ length: 35 }, (_, i) => {
    const day = i - 3; // start offset
    if (day < 1 || day > 31) return { day: '', empty: true };
    const written = [1, 2, 4, 5, 6, 7, 9, 10, 12, 14, 15, 16, 18, 19, 21, 22, 24, 26, 28, 29, 30].includes(day);
    const moodIdx = day % moodCols.length;
    return { day, written, mood: written ? moodCols[moodIdx] : null, today: day === 7 };
  });

  return (
    <div style={{ width: 402, height: 874, background: T2.paper, position: 'relative', fontFamily: T2.sans, color: T2.ink900, overflow: 'hidden' }}>
      <MiniStatusBar />

      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '46px 24px 0' }}>
        <div style={{ width: 36, height: 36, borderRadius: 18, background: T2.cream, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <svg width="14" height="14" viewBox="0 0 14 14" fill="none"><path d="M9 2L4 7l5 5" stroke={T2.ink900} strokeWidth="1.5" strokeLinecap="round"/></svg>
        </div>
        <div style={{ fontFamily: T2.serif, fontSize: 20, fontWeight: 500, fontStyle: 'italic' }}>journal</div>
        <div style={{ width: 36, height: 36 }} />
      </div>

      {/* Month header */}
      <div style={{ padding: '32px 28px 0' }}>
        <div style={{ fontFamily: T2.sans, fontSize: 12, letterSpacing: 2, color: T2.ink500, textTransform: 'uppercase', fontWeight: 600 }}>2026</div>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginTop: 4 }}>
          <h1 style={{ fontFamily: T2.serif, fontSize: 44, fontWeight: 400, letterSpacing: -1, margin: 0, lineHeight: 1 }}>
            May<span style={{ color: T2.terra300 }}>.</span>
          </h1>
          <div style={{ display: 'flex', gap: 6 }}>
            {['‹','›'].map((g, i) => (
              <div key={i} style={{ width: 32, height: 32, borderRadius: 16, background: T2.cream, display: 'flex', alignItems: 'center', justifyContent: 'center', color: T2.ink700, fontSize: 18 }}>{g}</div>
            ))}
          </div>
        </div>
        <div style={{ fontFamily: T2.serif, fontSize: 14, fontStyle: 'italic', color: T2.ink500, marginTop: 6 }}>21 entries · 4,872 words</div>
      </div>

      {/* Day-of-week labels */}
      <div style={{ padding: '28px 24px 0', display: 'grid', gridTemplateColumns: 'repeat(7, 1fr)', gap: 4 }}>
        {['S','M','T','W','T','F','S'].map((d, i) => (
          <div key={i} style={{ fontFamily: T2.sans, fontSize: 10, letterSpacing: 1.4, color: T2.ink500, textAlign: 'center', fontWeight: 700, padding: '4px 0' }}>{d}</div>
        ))}
      </div>

      {/* Grid */}
      <div style={{ padding: '4px 24px 0', display: 'grid', gridTemplateColumns: 'repeat(7, 1fr)', gap: 4 }}>
        {days.map((d, i) => (
          <div key={i} style={{
            aspectRatio: '1', borderRadius: 12, position: 'relative',
            background: d.today ? T2.ink900 : (d.written ? T2.cream : 'transparent'),
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            fontFamily: T2.serif, fontSize: 16, fontWeight: 400,
            color: d.today ? T2.paper : (d.empty ? T2.ink200 : T2.ink900),
          }}>
            {d.day}
            {d.written && !d.today && (
              <div style={{ position: 'absolute', bottom: 5, left: '50%', transform: 'translateX(-50%)', width: 5, height: 5, borderRadius: 3, background: d.mood }} />
            )}
            {d.today && (
              <div style={{ position: 'absolute', bottom: 5, left: '50%', transform: 'translateX(-50%)', width: 5, height: 5, borderRadius: 3, background: T2.terra200 }} />
            )}
          </div>
        ))}
      </div>

      {/* Mood legend */}
      <div style={{ padding: '24px 28px 0' }}>
        <div style={{ fontFamily: T2.sans, fontSize: 11, letterSpacing: 1.6, color: T2.ink500, textTransform: 'uppercase', fontWeight: 700, marginBottom: 10 }}>This month's moods</div>
        <div style={{ display: 'flex', gap: 12, flexWrap: 'wrap' }}>
          {[['calm', '#9CA888', 8], ['warm', '#B8896C', 6], ['restless', '#B89678', 4], ['hopeful', '#C9B080', 2], ['tender', '#D8A892', 1]].map(([n, c, count]) => (
            <div key={n} style={{ display: 'flex', alignItems: 'center', gap: 6, fontFamily: T2.sans, fontSize: 12, color: T2.ink700, fontWeight: 500 }}>
              <span style={{ width: 8, height: 8, borderRadius: 4, background: c }} />
              {n}
              <span style={{ color: T2.ink300, fontWeight: 400 }}>{count}</span>
            </div>
          ))}
        </div>
      </div>

      {/* Selected day card */}
      <div style={{ position: 'absolute', bottom: 50, left: 24, right: 24 }}>
        <div style={{ padding: '16px 18px', background: T2.terra50, borderRadius: 18 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
            <div style={{ fontFamily: T2.sans, fontSize: 11, letterSpacing: 1.6, color: T2.terra400, textTransform: 'uppercase', fontWeight: 700 }}>Today</div>
            <div style={{ fontFamily: T2.sans, fontSize: 11, color: T2.ink500, fontWeight: 600 }}>1 entry</div>
          </div>
          <div style={{ fontFamily: T2.serif, fontSize: 18, fontWeight: 500, marginTop: 4 }}>Long walk by the canal</div>
        </div>
      </div>

      <MiniHomeIndicator />
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// SEARCH — recent searches + tag pills + result
// ─────────────────────────────────────────────────────────────
function SearchView() {
  return (
    <div style={{ width: 402, height: 874, background: T2.cream, position: 'relative', fontFamily: T2.sans, color: T2.ink900, overflow: 'hidden' }}>
      <MiniStatusBar />

      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '46px 24px 0' }}>
        <div style={{ fontFamily: T2.sans, fontSize: 14, color: T2.ink500, fontWeight: 500 }}>Cancel</div>
        <div style={{ fontFamily: T2.serif, fontSize: 17, fontWeight: 500 }}>Search</div>
        <div style={{ width: 50 }} />
      </div>

      {/* Search field */}
      <div style={{ padding: '24px 24px 0' }}>
        <div style={{
          display: 'flex', alignItems: 'center', gap: 10, padding: '12px 16px',
          background: T2.paper, borderRadius: 14,
        }}>
          <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><circle cx="7" cy="7" r="5" stroke={T2.ink500} strokeWidth="1.5"/><path d="M11 11l3 3" stroke={T2.ink500} strokeWidth="1.5" strokeLinecap="round"/></svg>
          <input
            defaultValue="patience"
            style={{ flex: 1, border: 'none', background: 'transparent', outline: 'none', fontFamily: T2.sans, fontSize: 15, color: T2.ink900, fontWeight: 500 }}
          />
          <div style={{ width: 18, height: 18, borderRadius: 9, background: T2.ink300, display: 'flex', alignItems: 'center', justifyContent: 'center', color: T2.paper, fontSize: 11 }}>×</div>
        </div>
      </div>

      {/* Tags filter */}
      <div style={{ padding: '20px 24px 0' }}>
        <div style={{ fontFamily: T2.sans, fontSize: 11, letterSpacing: 1.6, color: T2.ink500, textTransform: 'uppercase', fontWeight: 700, marginBottom: 10 }}>Filter by tag</div>
        <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap' }}>
          {[['walking', true], ['reflection', false], ['family', false], ['memory', true], ['rest', false], ['change', false]].map(([t, on]) => (
            <div key={t} style={{
              padding: '6px 12px', borderRadius: 999,
              background: on ? T2.ink900 : T2.paper,
              color: on ? T2.paper : T2.ink700,
              fontFamily: T2.sans, fontSize: 12, fontWeight: 600,
            }}>{t}</div>
          ))}
        </div>
      </div>

      {/* Results */}
      <div style={{ padding: '24px 24px 0' }}>
        <div style={{ fontFamily: T2.sans, fontSize: 11, letterSpacing: 1.6, color: T2.ink500, textTransform: 'uppercase', fontWeight: 700, marginBottom: 10 }}>3 results</div>

        {[
          { title: 'Long walk by the canal', date: 'Wed, May 7', body: 'It made me think about <em>patience</em> — the kind that isn\'t waiting for anything.' },
          { title: 'On not knowing', date: 'Mon, May 5', body: 'Maybe sitting with the uncertainty is the work itself. <em>Patience</em> as practice.' },
          { title: 'A letter I never sent', date: 'Tue, May 6', body: 'I\'ve been learning that grief asks for <em>patience</em>.' },
        ].map((r, i) => (
          <div key={i} style={{
            padding: '14px 16px', background: T2.paper, borderRadius: 14, marginBottom: 8,
          }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 4 }}>
              <div style={{ fontFamily: T2.serif, fontSize: 16, fontWeight: 500 }}>{r.title}</div>
              <div style={{ fontFamily: T2.sans, fontSize: 11, color: T2.ink500, fontWeight: 500 }}>{r.date}</div>
            </div>
            <div
              dangerouslySetInnerHTML={{ __html: r.body.replace(/<em>/g, `<span style="background:${T2.terra50};color:${T2.terra400};padding:0 3px;border-radius:3px;font-style:normal;font-weight:600;">`).replace(/<\/em>/g, '</span>') }}
              style={{ fontFamily: T2.serif, fontSize: 14, lineHeight: 1.5, color: T2.ink700 }}
            />
          </div>
        ))}
      </div>

      <MiniHomeIndicator />
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// SETTINGS — grouped iOS list, warm
// ─────────────────────────────────────────────────────────────
function SettingsView() {
  const Row = ({ icon, title, detail, last, danger }) => (
    <div style={{
      display: 'flex', alignItems: 'center', minHeight: 50, padding: '0 16px', position: 'relative',
      borderBottom: last ? 'none' : `1px solid ${T2.hair}`,
    }}>
      {icon && <div style={{ width: 28, height: 28, borderRadius: 8, background: icon.bg, display: 'flex', alignItems: 'center', justifyContent: 'center', marginRight: 12 }}>
        <span style={{ fontFamily: T2.serif, fontSize: 14, color: icon.fg, fontStyle: 'italic' }}>{icon.glyph}</span>
      </div>}
      <div style={{ flex: 1, fontFamily: T2.sans, fontSize: 15, color: danger ? '#A04F3A' : T2.ink900, fontWeight: 500 }}>{title}</div>
      {detail && <div style={{ fontFamily: T2.sans, fontSize: 13, color: T2.ink500, marginRight: 6 }}>{detail}</div>}
      <svg width="6" height="10" viewBox="0 0 6 10" fill="none"><path d="M1 1l4 4-4 4" stroke={T2.ink300} strokeWidth="1.5" strokeLinecap="round"/></svg>
    </div>
  );
  const Card = ({ children, header }) => (
    <div style={{ marginBottom: 24 }}>
      {header && <div style={{ fontFamily: T2.sans, fontSize: 11, letterSpacing: 1.6, color: T2.ink500, textTransform: 'uppercase', fontWeight: 700, padding: '0 32px 8px' }}>{header}</div>}
      <div style={{ background: T2.paper, borderRadius: 18, margin: '0 20px', overflow: 'hidden' }}>{children}</div>
    </div>
  );

  return (
    <div style={{ width: 402, height: 874, background: T2.cream, position: 'relative', fontFamily: T2.sans, color: T2.ink900, overflow: 'hidden' }}>
      <MiniStatusBar />

      <div style={{ padding: '46px 24px 0', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <div style={{ width: 36, height: 36, borderRadius: 18, background: T2.paper, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <svg width="14" height="14" viewBox="0 0 14 14" fill="none"><path d="M9 2L4 7l5 5" stroke={T2.ink900} strokeWidth="1.5" strokeLinecap="round"/></svg>
        </div>
        <div style={{ fontFamily: T2.serif, fontSize: 17, fontWeight: 500 }}>You</div>
        <div style={{ width: 36 }} />
      </div>

      {/* Profile */}
      <div style={{ padding: '28px 24px 0', display: 'flex', flexDirection: 'column', alignItems: 'center', textAlign: 'center' }}>
        <div style={{
          width: 78, height: 78, borderRadius: 39, background: T2.terra100,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          fontFamily: T2.serif, fontSize: 36, fontStyle: 'italic', color: T2.terra400, fontWeight: 400,
        }}>m</div>
        <div style={{ fontFamily: T2.serif, fontSize: 22, fontWeight: 500, marginTop: 10 }}>Maya Chen</div>
        <div style={{ fontFamily: T2.serif, fontSize: 13, fontStyle: 'italic', color: T2.ink500, marginTop: 2 }}>Writing since March 2024</div>

        <div style={{ display: 'flex', gap: 32, marginTop: 18 }}>
          {[['247', 'entries'], ['23', 'streak'], ['58k', 'words']].map(([n, l]) => (
            <div key={l} style={{ textAlign: 'center' }}>
              <div style={{ fontFamily: T2.serif, fontSize: 22, fontWeight: 500 }}>{n}</div>
              <div style={{ fontFamily: T2.sans, fontSize: 11, letterSpacing: 1.2, color: T2.ink500, textTransform: 'uppercase', fontWeight: 600, marginTop: 2 }}>{l}</div>
            </div>
          ))}
        </div>
      </div>

      <div style={{ height: 32 }} />

      <Card header="Practice">
        <Row icon={{ bg: T2.terra100, fg: T2.terra400, glyph: 'p' }} title="Daily prompt" detail="9:00 PM" />
        <Row icon={{ bg: T2.sage100, fg: '#5C6F4F', glyph: 'r' }} title="Reminder" detail="Evening" />
        <Row icon={{ bg: T2.warm, fg: T2.ink700, glyph: 'm' }} title="Mood tracking" detail="On" last />
      </Card>

      <Card header="Privacy">
        <Row icon={{ bg: T2.cream, fg: T2.ink700, glyph: '◔' }} title="Lock with Face ID" detail="On" />
        <Row icon={{ bg: T2.cream, fg: T2.ink700, glyph: '↓' }} title="Export & backup" last />
      </Card>

      <MiniHomeIndicator />
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// MOOD CHECK-IN — full-screen mood selector
// ─────────────────────────────────────────────────────────────
function MoodCheckIn() {
  const moods = [
    { name: 'tender',   color: '#E8C4B0', dot: '#D8A892' },
    { name: 'calm',     color: '#DCDDC7', dot: '#9CA888' },
    { name: 'warm',     color: '#EDD3BD', dot: '#B8896C' },
    { name: 'hopeful',  color: '#E5D2A8', dot: '#C9B080' },
    { name: 'restless', color: '#D9B895', dot: '#B89678' },
    { name: 'heavy',    color: '#C9B8A8', dot: '#8B7E6E' },
  ];

  return (
    <div style={{ width: 402, height: 874, background: T2.terra50, position: 'relative', fontFamily: T2.sans, color: T2.ink900, overflow: 'hidden' }}>
      <MiniStatusBar />

      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '46px 24px 0' }}>
        <div style={{ fontFamily: T2.sans, fontSize: 14, color: T2.ink500, fontWeight: 500 }}>Skip</div>
        <div style={{ display: 'flex', gap: 4 }}>
          {[1, 2, 3].map((i) => (
            <div key={i} style={{ width: 18, height: 3, borderRadius: 2, background: i === 1 ? T2.ink900 : T2.hairStrong }} />
          ))}
        </div>
        <div style={{ fontFamily: T2.sans, fontSize: 14, color: T2.ink900, fontWeight: 600 }}>Next</div>
      </div>

      <div style={{ padding: '70px 32px 0' }}>
        <div style={{ fontFamily: T2.sans, fontSize: 12, letterSpacing: 2, color: T2.terra400, textTransform: 'uppercase', fontWeight: 700 }}>Tonight</div>
        <h1 style={{ fontFamily: T2.serif, fontSize: 38, fontWeight: 400, lineHeight: 1.1, letterSpacing: -0.6, margin: '12px 0 0' }}>
          How would you<br/>describe today<span style={{ color: T2.terra300 }}>?</span>
        </h1>
        <div style={{ fontFamily: T2.serif, fontSize: 16, fontStyle: 'italic', color: T2.ink500, marginTop: 12 }}>
          Pick one. There's no wrong answer.
        </div>
      </div>

      {/* Mood circles */}
      <div style={{ padding: '50px 32px 0', display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 20, justifyItems: 'center' }}>
        {moods.map((m, i) => (
          <div key={m.name} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 10 }}>
            <div style={{
              width: 78, height: 78, borderRadius: 39, background: m.color,
              border: i === 1 ? `3px solid ${T2.ink900}` : 'none',
              boxShadow: i === 1 ? `0 0 0 5px ${T2.terra50}, 0 8px 20px rgba(58,51,43,0.12)` : '0 4px 12px rgba(58,51,43,0.06)',
              position: 'relative',
            }}>
              {i === 1 && (
                <div style={{ position: 'absolute', bottom: -3, right: -3, width: 22, height: 22, borderRadius: 11, background: T2.ink900, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                  <svg width="10" height="8" viewBox="0 0 10 8" fill="none"><path d="M1 4l3 3 5-6" stroke={T2.paper} strokeWidth="1.6" strokeLinecap="round"/></svg>
                </div>
              )}
            </div>
            <div style={{ fontFamily: T2.serif, fontSize: 15, fontWeight: i === 1 ? 600 : 400, color: T2.ink900 }}>
              {m.name}
            </div>
          </div>
        ))}
      </div>

      {/* Note input */}
      <div style={{ position: 'absolute', bottom: 130, left: 24, right: 24 }}>
        <div style={{ fontFamily: T2.sans, fontSize: 11, letterSpacing: 1.6, color: T2.ink500, textTransform: 'uppercase', fontWeight: 700, marginBottom: 8 }}>One word for today (optional)</div>
        <div style={{ padding: '14px 16px', background: T2.paper, borderRadius: 14, fontFamily: T2.serif, fontStyle: 'italic', fontSize: 16, color: T2.ink300 }}>
          gentle, slow, golden…
        </div>
      </div>

      <div style={{ position: 'absolute', bottom: 36, left: 24, right: 24 }}>
        <button style={{
          width: '100%', padding: '16px', background: T2.ink900, color: T2.paper,
          border: 'none', borderRadius: 18, fontFamily: T2.sans, fontSize: 15, fontWeight: 600,
        }}>Continue to writing</button>
      </div>

      <MiniHomeIndicator />
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// ONBOARDING — welcome
// ─────────────────────────────────────────────────────────────
function Onboarding() {
  return (
    <div style={{ width: 402, height: 874, background: T2.paper, position: 'relative', fontFamily: T2.sans, color: T2.ink900, overflow: 'hidden' }}>
      <MiniStatusBar />

      {/* decorative blobs */}
      <div style={{ position: 'absolute', top: 90, right: -60, width: 220, height: 220, borderRadius: '50%', background: T2.terra50, zIndex: 1 }} />
      <div style={{ position: 'absolute', top: 240, left: -40, width: 140, height: 140, borderRadius: '50%', background: T2.sage100, zIndex: 1 }} />
      <div style={{ position: 'absolute', top: 380, right: 60, width: 80, height: 80, borderRadius: '50%', background: T2.terra100, opacity: 0.7, zIndex: 1 }} />

      <div style={{ position: 'absolute', inset: 0, display: 'flex', flexDirection: 'column', justifyContent: 'space-between', padding: '120px 32px 36px', zIndex: 5 }}>
        <div>
          <div style={{
            width: 56, height: 56, borderRadius: 28, background: T2.ink900,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            fontFamily: T2.serif, fontSize: 30, fontStyle: 'italic', color: T2.paper, fontWeight: 400,
          }}>j</div>
          <h1 style={{ fontFamily: T2.serif, fontSize: 48, fontWeight: 400, lineHeight: 1.05, letterSpacing: -1.2, margin: '40px 0 0' }}>
            A quiet place<br/>for your<br/><em style={{ fontStyle: 'italic', color: T2.terra300 }}>thinking.</em>
          </h1>
          <div style={{ fontFamily: T2.serif, fontSize: 17, fontStyle: 'italic', color: T2.ink500, lineHeight: 1.5, marginTop: 22, maxWidth: 280 }}>
            Five minutes. One prompt. Nobody watching. Just you and the page.
          </div>
        </div>

        <div>
          <button style={{
            width: '100%', padding: '17px', background: T2.ink900, color: T2.paper,
            border: 'none', borderRadius: 999, fontFamily: T2.sans, fontSize: 15, fontWeight: 600,
            marginBottom: 12,
          }}>Begin your first entry</button>
          <button style={{
            width: '100%', padding: '13px', background: 'transparent', color: T2.ink700,
            border: 'none', fontFamily: T2.sans, fontSize: 14, fontWeight: 500,
          }}>I already have an account</button>
        </div>
      </div>

      <MiniHomeIndicator />
    </div>
  );
}

Object.assign(window, { CalendarMonth, SearchView, SettingsView, MoodCheckIn, Onboarding });
