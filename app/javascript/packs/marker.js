// marker.js
async function initMarkers(posts) {
  const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");

  posts.forEach((post) => {
    const position = { lat: post.latitude, lng: post.longitude };

    new AdvancedMarkerElement({
      position: position,
      map: map,
      title: post.title, // 吹き出しのタイトル
    });
  });
}

// マーカー情報を取得して適用
document.addEventListener("DOMContentLoaded", function () {
  const postsDataElement = document.getElementById("posts-data");

  if (postsDataElement) {
    const posts = JSON.parse(postsDataElement.dataset.posts);
    initMarkers(posts);
  }
});