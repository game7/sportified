export default function sortArray(properties) {

  let props = [].concat(properties);
  return function(itemA, itemB) {
    for(var i = 0; i < props.length; i++) {
      let prop = props[i];
      let a = itemA.get(prop);
      let b = itemB.get(prop);
      if (a > b) {
        return 1;
      } else if (a < b) {
        return -1
      }
    }
    return 0;
  }

}
