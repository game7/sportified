import * as moment from 'moment';

export const Format = {

  currency: (value: number) => {
    return (Math.round(value * 100) / 100).toFixed(2)
  },

  dollars: (value: number) => {
    return `$${(Math.round(value * 100) / 100).toFixed(0).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")}`
  },

  timeAgo: (date: Date) => moment(new Date(date)).fromNow(),

  shortDate: (date: Date) => moment(date).format('M/D/YY')

}

export function Sort<T>(array: T[]) {

  function asc(attribute: (T) => any): T[] {
    function comparer(a: T, b: T) {
      const aValue = attribute(a);
      const bValue = attribute(b);
      if (aValue > bValue) return 1
      if (aValue < bValue) return -1
      return 0
    }
    return array.sort(comparer)
  }

  function desc(attribute: (T) => any): T[] {
    function comparer(a: T, b: T) {
      const aValue = attribute(a);
      const bValue = attribute(b);
      if (aValue < bValue) return 1
      if (aValue > bValue) return -1
      return 0
    }
    return array.sort(comparer)
  }

  return {
    asc: asc,
    desc: desc
  }
}

export function Export(filename: string, rows: any[]) {
  var processRow = function (row) {
      var finalVal = '';
      for (var j = 0; j < row.length; j++) {
          var innerValue = row[j] === null ? '' : row[j].toString();
          if (row[j] instanceof Date) {
              innerValue = row[j].toLocaleString();
          };
          var result = innerValue.replace(/"/g, '""');
          if (result.search(/("|,|\n)/g) >= 0)
              result = '"' + result + '"';
          if (j > 0)
              finalVal += ',';
          finalVal += result;
      }
      return finalVal + '\n';
  };

  var csvFile = '';
  for (var i = 0; i < rows.length; i++) {
      csvFile += processRow(rows[i]);
  }

  var blob = new Blob([csvFile], { type: 'text/csv;charset=utf-8;' });
  if (navigator.msSaveBlob) { // IE 10+
      navigator.msSaveBlob(blob, filename);
  } else {
      var link = document.createElement("a");
      if (link.download !== undefined) { // feature detection
          // Browsers that support HTML5 download attribute
          var url = URL.createObjectURL(blob);
          link.setAttribute("href", url);
          link.setAttribute("download", filename);
          link.style.visibility = 'hidden';
          document.body.appendChild(link);
          link.click();
          document.body.removeChild(link);
      }
  }
}
