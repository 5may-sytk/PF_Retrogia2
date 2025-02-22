document.addEventListener('DOMContentLoaded', function() {
  const inputField = document.querySelector('#image_tags'); // image_tagsフィールドを取得
  const form = document.querySelector('form'); // フォームを取得

  form.addEventListener('submit', function(event) {
      let tagsArray = inputField.value.split(" "); // 入力値をスペースで分割して配列に

      // 入力された各タグに"＃"を先頭に付与する
      tagsArray = tagsArray.map(tag => tag.startsWith('＃') ? tag : `＃${tag}`);

      // 元の入力フィールドに加工したタグを結合してセット
      inputField.value = tagsArray.join(" ");
  });
});