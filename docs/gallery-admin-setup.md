# Mise en service de la galerie photo

La galerie est intégrée à la page d'accueil dans la branche `phase-2/gallery-photo-admin`. Elle reste vide tant que les médias et la configuration Supabase ne sont pas ajoutés. **Aucun changement n'est déployé en production par cette branche.**

## 1. Créer le stockage et les règles d'accès

1. Créez ou sélectionnez le projet Supabase destiné au site.
2. Ouvrez **SQL Editor** et exécutez le contenu de `docs/gallery-supabase-setup.sql`.
3. Dans **Authentication > Users**, créez le compte de la personne qui administrera la galerie.
4. Dans le SQL Editor, remplacez l'adresse ci-dessous par l'adresse exacte de ce compte puis exécutez la requête pour lui attribuer le rôle d'administration :

```sql
update auth.users
set raw_app_meta_data = coalesce(raw_app_meta_data, '{}'::jsonb) || '{"role":"admin"}'::jsonb
where email = 'administrateur@exemple.cm';
```

Cette attribution doit être faite par un propriétaire autorisé du projet Supabase. Ne donnez le rôle qu'à des personnes de confiance. Après cette modification, déconnectez-vous puis reconnectez-vous pour obtenir un nouveau jeton d'accès.

## 2. Configurer le site

Ouvrez `media/gallery-config.js` et remplacez :

- `VOTRE_URL_SUPABASE` par l'URL du projet Supabase ;
- `VOTRE_CLE_ANON_SUPABASE` par la clé publique **anon/publishable** du projet.

Ces deux valeurs sont conçues pour être visibles dans le navigateur ; la sécurité est assurée par les politiques RLS et les règles de stockage. **N'utilisez jamais la clé `service_role` dans le site, dans GitHub ou dans ce fichier.**

## 3. Utilisation

1. Ouvrez la page d'accueil et allez à **Galerie**.
2. Cliquez sur **Administration de la galerie**, puis connectez-vous.
3. Ajoutez une image JPG, PNG ou WebP de 8 Mo maximum, un titre, un texte alternatif et une catégorie.
4. Choisissez si elle doit être publiée immédiatement. Les brouillons ne sont visibles que par l'administrateur.
5. Publiez, dépubliez ou supprimez les photos depuis la liste d'administration.

Les images publiques sont accessibles par URL : n'y déposez pas de documents privés. Vérifiez que vous avez le consentement des personnes photographiées, notamment des mineurs, avant publication.

## 4. Contrôles avant validation

- Tester le rendu sur mobile et ordinateur.
- Tester les filtres et l'ouverture/fermeture de la visionneuse.
- Vérifier qu'un visiteur non connecté ne voit que les photos publiées.
- Vérifier qu'un compte ordinaire ne peut ni téléverser ni modifier des photos.
- Tester la connexion admin, l'ajout, la publication, la dépublication et la suppression.
- Vérifier les politiques RLS et les politiques du bucket avant de fusionner la PR.

La galerie ne peut pas réellement téléverser de photos avant d'avoir renseigné les paramètres du projet Supabase et exécuté le SQL.
