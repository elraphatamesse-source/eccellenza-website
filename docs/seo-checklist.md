# Référencement naturel — L’Eccellenza

Ce document accompagne le prototype Vercel de la branche `phase-2/gallery-photo-admin`. Le site est actuellement une page vitrine statique avec des sections d’ancrage : le sitemap ne doit donc contenir que l’URL d’accueil tant que des pages distinctes n’existent pas.

## Éléments déjà présents dans `index.html`

- Langue du document : français (`lang="fr"`), modifiée selon la langue choisie.
- Titre de page et méta-description.
- Directive `robots` et URL canonique vers `https://eccellenza.cm`.
- Balises Open Graph et Twitter Card.
- Données structurées Schema.org de type `EducationalOrganization`.
- Structure de titres, lien d’évitement, textes alternatifs pour les photos de galerie et chargement différé des images.
- Liens de contact, téléphone, WhatsApp et adresse.

## Fichiers ajoutés

- `/robots.txt` : autorise l’exploration et déclare le sitemap officiel.
- `/sitemap.xml` : déclare la page d’accueil canonique `https://eccellenza.cm/`.

## Contrôles à effectuer sur la Preview Vercel

1. Vérifier que `/robots.txt` et `/sitemap.xml` renvoient HTTP 200 et un contenu correct.
2. Vérifier l’absence d’erreurs JavaScript et les liens, formulaires, menu mobile et langues FR/EN/IT.
3. Vérifier l’affichage mobile, les dimensions d’images, la navigation clavier, les contrastes et les textes alternatifs.
4. Vérifier le titre, la méta-description, la canonical, les balises Open Graph/Twitter et le JSON-LD dans le code source.
5. Tester les performances avec Lighthouse (mobile et desktop), puis corriger les problèmes de performance et d’accessibilité avant validation.
6. Vérifier les informations métier (adresse, téléphone, horaires, services, niveaux et chiffres de présentation) avec le responsable du centre avant publication.
7. Après mise en ligne sur le domaine officiel, vérifier le sitemap et demander l’indexation via Google Search Console et Bing Webmaster Tools.

## Précautions avant production

- Le prototype utilise une URL canonique vers `https://eccellenza.cm` pour éviter de présenter le domaine Vercel comme URL officielle.
- Ne pas soumettre l’URL Preview comme propriété principale dans les outils de recherche.
- Vérifier que les chiffres de présentation, témoignages, horaires et données d’adresse sont exacts et autorisés à être publiés.
- Ne pas inclure de secrets Supabase dans le dépôt. La clé publishable/anon peut être utilisée côté client avec des politiques RLS correctement configurées ; ne jamais exposer une clé `service_role`.
- Les photos du bucket public doivent être des médias autorisés à être publiés.
