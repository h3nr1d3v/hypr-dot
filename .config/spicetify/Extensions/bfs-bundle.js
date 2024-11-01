(() => {
  "use strict";

  const styles = {
    bfs: "TRekod_IruALWIbC7kc_",
    container: "Bw1uxJEPtat9U7tHEH8n",
    visible: "FgzDsOFfhY82OYAlXHQk",
    foreground: "o_1lpMfGLc4G1rkQtT9D",
    left: "US8wZucpYzlbQHXEAe2t",
    details: "xjPvZsYBmOdDXOtem70e"
  };

  function BeautifulFullscreen() {
    const { React } = Spicetify;
    const { useState, useEffect } = React;

    const [visible, setVisible] = useState(false);
    const [title, setTitle] = useState("");
    const [artist, setArtist] = useState("");
    const [coverURL, setCoverURL] = useState("");

    useEffect(() => {
      const updateTrackInfo = () => {
        const metadata = Spicetify.Player.data.item.metadata;
        setTitle(metadata.title);
        setArtist(metadata.artist_name);
        setCoverURL(metadata.image_xlarge_url);
      };

      updateTrackInfo();
      Spicetify.Player.addEventListener("songchange", updateTrackInfo);

      return () => {
        Spicetify.Player.removeEventListener("songchange", updateTrackInfo);
      };
    }, []);

    if (!visible) return null;

    return React.createElement("div", {
      className: `${styles.container} ${styles.visible}`,
      id: "bfs-container",
      onDoubleClick: () => setVisible(false),
    },
      React.createElement("div", { className: styles.foreground },
        React.createElement("div", { className: styles.left },
          React.createElement("img", { src: coverURL, alt: "Album Cover" }),
          React.createElement("div", { className: styles.details },
            React.createElement("div", { id: "bfs-title" }, title),
            React.createElement("div", { id: "bfs-artist" }, artist)
          )
        )
      )
    );
  }

  function initializeBeautifulFullscreen() {
    if (!Spicetify.Keyboard || !Spicetify.React || !Spicetify.ReactDOM || !document.querySelector(".main-topBar-container")) {
      setTimeout(initializeBeautifulFullscreen, 200);
      return;
    }

    const container = document.createElement("div");
    container.id = "beautiful-fullscreen-container";
    document.body.appendChild(container);

    let isFullscreenVisible = false;

    new Spicetify.Topbar.Button(
      "Beautiful Fullscreen",
      `<svg role="img" height="16" width="16" viewBox="0 0 16 16" fill="currentColor">${Spicetify.SVGIcons.visualizer}</svg>`,
      () => {
        isFullscreenVisible = !isFullscreenVisible;
        Spicetify.ReactDOM.render(
          Spicetify.React.createElement(BeautifulFullscreen, { visible: isFullscreenVisible }),
          container
        );
      }
    );
  }

  initializeBeautifulFullscreen();
})();
