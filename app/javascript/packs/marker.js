async function initMarkers(posts) {
  try {
    const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");

    if (!map) {
      console.error("Google Map が読み込まれていません");
      return;
    }

    posts.forEach((post) => {
      const position = { lat: post.latitude, lng: post.longitude };

      new AdvancedMarkerElement({
        position: position,
        map: map,
        title: post.title, // 吹き出しのタイトル
      });
    });
  } catch (error) {
    console.error("マーカーのロード中にエラーが発生しました:", error);
  }
}

// マーカー情報を取得して適用
document.addEventListener("turbolinks:load", function () {
  const postsDataElement = document.getElementById("posts-data");

  if (!postsDataElement) {
    console.warn("投稿データが見つかりません");
    return;
  }

  try {
    const posts = JSON.parse(postsDataElement.dataset.posts);
    initMarkers(posts);
  } catch (error) {
    console.error("投稿データの解析に失敗しました:", error);
  }
});