# Image Tiler - Générateur de Tuiles Multi-niveaux

Ce script PowerShell permet de prendre une image source et de la découper en une grille de tuiles (tiles) au format `.png`. Il génère automatiquement **6 niveaux de zoom** (de 0 à 5), organisés dans une structure de dossiers spécifique.

## 🚀 Fonctionnement
Le script réduit progressivement la résolution de l'image originale :
*   **Zoom 5** : Taille réelle de l'image.
*   **Zoom 0** : Taille la plus réduite (échelle $2^{-5}$).
*   Chaque niveau est découpé en carrés de **256x256 pixels**.

---

## 📂 Structure de sortie
Les images sont classées selon l'arborescence suivante :
`Racine\Zoom\Axe_Y\Axe_X.png`

**Exemple :**
*   `C:\temp\CreationTiles\0\0\0.png` (Tuile du coin haut-gauche au zoom minimal)
*   `C:\temp\CreationTiles\4\9\4.png` (Tuile spécifique au zoom 4)

---

## 🛠️ Installation et Utilisation

### 1. Préparation dans PowerShell ISE
1.  Ouvrez **PowerShell ISE**
2.  Copiez le code du script et collez-le dans l'éditeur.
3.  **Important :** Modifiez les deux premières lignes de la section `# --- Configuration ---` pour qu'elles correspondent à vos chemins :
    *   `$sourceFile` : Le chemin complet de votre image (ex: `C:\temp\Fonds.png`).
    *   `$outputBaseFolder` : L'endroit où les dossiers seront créés.
4.  Enregistrez le fichier sur votre **Bureau** sous le nom `CréationTuiles.ps1`.

### 2. Exécution du script
Comme Windows bloque parfois l'exécution de scripts par sécurité, utilisez la commande suivante pour lancer le traitement.

1.  Ouvrez un terminal PowerShell.
2.  Copiez et collez cette commande :
    ```powershell
    powershell -ExecutionPolicy Bypass -File "$home\Desktop\CréationTuiles.ps1"
    ```

---

## ⚙️ Paramètres techniques
| Paramètre | Description |
| :--- | :--- |
| **Add-Type** | Charge la bibliothèque `.NET System.Drawing` pour manipuler les images. |
| **$tileSize** | Définit la taille des tuiles (par défaut 256px). |
| **Interpolation** | Utilise le mode `HighQualityBicubic` pour garantir que les images restent nettes lors de la réduction de taille. |
| **Dispose()** | Le script libère la mémoire vive (RAM) après chaque étape pour éviter les plantages sur les grosses images. |

---

## ⚠️ Prérequis
*   **Windows** avec PowerShell installé.
*   L'image source doit être accessible en lecture.
*   L'extension de fichier dans le script (`.png` ou `.jpg`) doit correspondre exactement à votre fichier source.
```
