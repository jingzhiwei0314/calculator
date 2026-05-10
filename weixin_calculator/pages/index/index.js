function tapFeedback() {
  if (wx.vibrateShort) {
    wx.vibrateShort({ type: 'light' });
  }
}

function tokenize(expr) {
  const tokens = [];
  let i = 0;
  while (i < expr.length) {
    const c = expr[i];
    if (c === '+' || c === '-' || c === '*' || c === '/') {
      tokens.push(c);
      i += 1;
      continue;
    }
    if ((c >= '0' && c <= '9') || c === '.') {
      let j = i;
      while (j < expr.length && /[\d.]/.test(expr[j])) j += 1;
      tokens.push(expr.slice(i, j));
      i = j;
      continue;
    }
    i += 1;
  }
  return tokens;
}

function isOperator(t) {
  return t === '+' || t === '-' || t === '*' || t === '/';
}

function precedence(op) {
  if (op === '+' || op === '-') return 1;
  if (op === '*' || op === '/') return 2;
  return 0;
}

function toRpn(tokens) {
  const output = [];
  const stack = [];
  for (let k = 0; k < tokens.length; k += 1) {
    const t = tokens[k];
    if (!isOperator(t)) {
      output.push(t);
      continue;
    }
    while (
      stack.length > 0 &&
      isOperator(stack[stack.length - 1]) &&
      precedence(stack[stack.length - 1]) >= precedence(t)
    ) {
      output.push(stack.pop());
    }
    stack.push(t);
  }
  while (stack.length > 0) output.push(stack.pop());
  return output;
}

function evalRpn(rpn) {
  const st = [];
  for (let i = 0; i < rpn.length; i += 1) {
    const t = rpn[i];
    if (!isOperator(t)) {
      st.push(parseFloat(t, 10));
      continue;
    }
    const b = st.pop();
    const a = st.pop();
    if (t === '+') st.push(a + b);
    else if (t === '-') st.push(a - b);
    else if (t === '*') st.push(a * b);
    else if (t === '/') st.push(a / b);
  }
  return st[0];
}

function evaluateExpression(raw) {
  const expr = raw.replace(/×/g, '*').replace(/÷/g, '/').trim();
  if (!expr) return NaN;
  const tokens = tokenize(expr);
  if (tokens.length === 0) return NaN;
  const rpn = toRpn(tokens);
  const v = evalRpn(rpn);
  return v;
}

function formatResult(v) {
  if (typeof v !== 'number' || Number.isNaN(v) || !Number.isFinite(v)) return null;
  if (v === Math.round(v)) return String(Math.round(v));
  let s = String(v);
  if (s.includes('.')) {
    s = s.replace(/\.?0+$/, '');
    if (s.endsWith('.')) s = s.slice(0, -1);
  }
  return s;
}

Page({
  data: {
    display: '',
  },

  onAppend(e) {
    tapFeedback();
    const ch = e.currentTarget.dataset.ch;
    if (ch === undefined || ch === null) return;
    this.setData({
      display: this.data.display + String(ch),
    });
  },

  onClear() {
    tapFeedback();
    this.setData({ display: '' });
  },

  onEquals() {
    tapFeedback();
    const expr = this.data.display;
    if (!expr) return;
    try {
      const v = evaluateExpression(expr);
      const out = formatResult(v);
      if (out === null) {
        this.setData({ display: '错啦' });
        return;
      }
      this.setData({ display: out });
    } catch (_) {
      this.setData({ display: '错啦' });
    }
  },
});
