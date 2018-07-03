
export function getTextColor(backgroundHexColor: string) {
  const parts = /^#?([A-Fa-f\d]{2})([A-Fa-f\d]{2})([A-Fa-f\d]{2})/i.exec(backgroundHexColor);
  const r = parseInt(parts[1], 16);
  const g = parseInt(parts[2], 16);
  const b = parseInt(parts[3], 16);
  const a = 1 - (0.299 * r + 0.587 * g + 0.114 * b) / 255;
  return (a < 0.5) ? '#000000' : '#ffffff';
}
