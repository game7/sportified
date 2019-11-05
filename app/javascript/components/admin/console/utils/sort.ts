export function asc<T>(collection: T[], by: keyof T) {
  return collection.sort((a, b) => {
    if(a[by] < b[by]) { return -1 }
    if(a[by] > b[by]) { return 1}
    return 0
  })
}

export function desc<T>(collection: T[], by: keyof T) {
  return collection.sort((a, b) => {
    if(a[by] < b[by]) { return 1 }
    if(a[by] > b[by]) { return -1 }
    return 0
  })
}
