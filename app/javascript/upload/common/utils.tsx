

export function asc<T>(keySelector: ($: T) => any): (a: T,b: T) => number {
  return (a, b) => {
    const valOfA = keySelector(a);
    const valOfB = keySelector(b);
    if(valOfA > valOfB) return 1;
    if(valOfA < valOfB) return -1;
    return 0;
  };
}
