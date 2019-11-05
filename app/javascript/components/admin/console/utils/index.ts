import { LocationListener, Location } from 'history';

export function getTextColor(backgroundHexColor: string, dark = '#000000', light = '#ffffff') {
  if(!backgroundHexColor) { return dark }
  const parts = /^#?([A-Fa-f\d]{2})([A-Fa-f\d]{2})([A-Fa-f\d]{2})/i.exec(backgroundHexColor);
  if(!parts) { return dark }
  if(parts.length !== 4) { return dark }
  const r = parseInt(parts[1], 16);
  const g = parseInt(parts[2], 16);
  const b = parseInt(parts[3], 16);
  const a = 1 - (0.299 * r + 0.587 * g + 0.114 * b) / 255;
  return (a < 0.5) ? dark : light;
}

export function n(n: number) {
  return {
    times: function<T>(callback: (i: number) => T) {
      let result: T[] = []
      for(var x = 0; x < n; x++) {
        result.push(callback(x))
      }
      return result
    }
  }
}

export function range(start: number, end: number) {
  return {
    each: function(callback: (i: number) => void) {
      for(var i = start; i <= end; i++) {
        callback(i)
      }
    }
  }
}

interface Grouping<T> {
  items: T[]
  blanks: number
}

export function group<T>(array: T[]) {
  return {
    by: function(n: number) {
      const groups: Grouping<T>[] = [];
      for(var i = 0; i < array.length; i += n) {
        const slice = array.slice(i, i + n)
        groups.push({
          items: slice,
          blanks: n - slice.length
        })
      }
      return groups;
    }
  }
}

export function times(count: number, seed = 'x') {
  return seed.repeat(count).split('')
}

export function pluck<T>(object: T, ...keys: Array<keyof T>) : Partial<T> {
  return keys.reduce((result, key) => (
    {
      ...result,
      [key]: object[key]
    }
  ), {})
}

export function groupsOf<T>(array: T[], n: number) {
  let result = [];
  for(var i = 0; i < array.length; i += n) {
    result.push(array.slice(i, i + n))
  }
  return result as T[][];
}
export const previous = (function() {

  const PREVIOUS = '@history/previous'
  const CURRENT = '@history/current'

  const watch: LocationListener = function watch(location, action) {
    const current = (sessionStorage.getItem(CURRENT) ? JSON.parse(sessionStorage.getItem(CURRENT)) : null) as Location
    if(current && current.pathname !== location.pathname) {
      sessionStorage.setItem(PREVIOUS, JSON.stringify(current))
    }
    sessionStorage.setItem(CURRENT, JSON.stringify(location))
  }

  const location = function() {
    return sessionStorage.getItem(PREVIOUS) ? JSON.parse(sessionStorage.getItem(PREVIOUS)) : null
  }

  return {
    watch,
    location
  }
})()
