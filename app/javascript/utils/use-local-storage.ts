import { useState } from "react";

export function useLocalStorage<T>(
  key: string,
  initial?: T
): [T | undefined, (value: T | null) => void] {
  //
  const [state, setState] = useState<T | undefined>(() => {
    try {
      const value = localStorage.getItem(key);
      return value ? JSON.parse(value) : initial;
    } catch (error) {
      console.log(error);
      return initial;
    }
  });

  function setValue(value: T | null | undefined) {
    if (value) {
      localStorage.setItem(key, JSON.stringify(value));
    } else {
      localStorage.removeItem(key);
    }
    setState(value ? value : undefined);
  }

  return [state, setValue];
}
