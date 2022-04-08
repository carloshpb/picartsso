import '../models/style_image.dart';

class StyleImageConstants {
  static const StyleImage waterLilies = StyleImage(
    artName: 'Nenúfares',
    authorName: 'Claude Monet',
    path: 'assets/style_imgs/Claude_Monet_-_Water_Lilies.jpg',
  );
  static const StyleImage guernica = StyleImage(
    artName: 'Guernica',
    authorName: 'Pablo Picasso',
    path: 'assets/style_imgs/Guernica-Pablo-Picasso.jpg',
  );
  static const StyleImage lesDemoisellesdAvignon = StyleImage(
    artName: "Les Demoiselles d'Avignon",
    authorName: 'Pablo Picasso',
    path: 'assets/style_imgs/Les-Demoiselles-dAvignon-Pablo-Picasso.jpg',
  );
  static const StyleImage theScream = StyleImage(
    artName: "O Grito",
    authorName: 'Edvard Munch',
    path: 'assets/style_imgs/The_Scream.jpg',
  );
  static const StyleImage thePersistenceOfMemory = StyleImage(
    artName: "A Persistência da Memória",
    authorName: 'Salvador Dalí',
    path: 'assets/style_imgs/the-persistence-of-memory-1931.jpg',
  );
  static const StyleImage theStarryNightDeSterrennacht = StyleImage(
    artName: "A Noite Estrelada",
    authorName: 'Vincent van Gogh',
    path:
        'assets/style_imgs/The-Starry-Night-De-sterrennacht-by-Vincent-Van-Gogh.jpg',
  );
  static final List<StyleImage> listStyleImages = <StyleImage>[
    waterLilies,
    guernica,
    lesDemoisellesdAvignon,
    theScream,
    thePersistenceOfMemory,
    theStarryNightDeSterrennacht,
  ];
}
