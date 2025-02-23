export const setCurrentTime = () => {
  // 現在のローカル時間を取得
  const now = new Date();
  // 日本時間に変換
  const jpTime = new Date(now.getTime() + (9*60*60*1000)); // UTCと日本時間の時差を加える
  // 日本時間のフォーマットに変換
  const jpTimeFormatted = jpTime.toISOString().slice(0, 16); // YYYY-MM-DDTHH:MMまでのフォーマット
  // 入力フォームに現在時刻を設定
  document.getElementById("timeInput").value = jpTimeFormatted;
};

window.setCurrentTime = setCurrentTime;