# -*- coding: utf-8 -*-
"""ProducerWikiScrapers.ipynb


# Acquiring More Data for the Model

The purpose of the following scripts is to acquire more data to add to the existing dataset, which contains the discographies of artists who Antonoff has collaborated with both before and during their collaborations. The songs they collaborated with are tagged in the binary column "jack", with 1 indicated that the song is a collaboration.

The first new kind of data is **songs produced by similar pop producers**. This involves scraping discographies from producers' wikipedia pages, and requesting audio features using the `audio_features()` function from the  `spotipy` package. The scripts for each producer are the same, with slight variations for descripancies scraping Wikipedia pages (for instance, unreleased songs listed on Wikipedia are not included in the request).

The second new kind of data is **similar songs**. Here, I use a custom `get_recommendations` function, which is similar to the `recommendations` function in `spotipy`. This function accesses the Spotify Web API's recommendations endpoint using the existing dataset's tracks as seed tracks to fetch tracks that might share musical characteristics with the songs from the existing dataset. In order to manage rate-limiting, it retrieves recommendations in batches of five, and waits and retries, if necessary. (As of right now, I'm only using songs produced by Antonoff as seed tracks).



------

### Appendix:

Carl Wilson offered suggestions on who to compare Antonoff's production style to: " **Max Martin**  is definitely one who comes to mind because of the contrast via Swift. But comparing to Dr. Luke is going to get you more genre differences than production style contrast. for people a little closer to the areas Jack works in - you might look at ppl like **Greg Kurstin** , **Paul Epworth** (both Adele producers but also for many others), **Mark Ronson**, **Joel Little** (Lorde’s producer before Jack), **Ariel Rechtshaid**, maybe **Dave Cobb** or **Jay Joyce** for the country end, even **Finneas** (Billie Eilish’s brother who pretty much only works with her) because his approach has some overlap with Antonoff’s, I think."

As a list:
- Max Martin
- Greg Kurstin
- Paul Epworth
- Mark Ronson
- Joel Little
- Ariel Rechtshaid
- Dave Cobb (country)
- Jay Joyce (country)
- Finneas
"""

#PACKAGES
!pip install spotipy
import requests
from bs4 import BeautifulSoup
import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
import time
import pandas as pd

"""##Max Martin - done

Scraping songs from Wiki: https://en.wikipedia.org/wiki/Max_Martin_production_discography
"""

url = "https://en.wikipedia.org/wiki/Max_Martin_production_discography"

response = requests.get(url)
soup = BeautifulSoup(response.content, 'html.parser')


tables = soup.findAll('table', {'class': 'wikitable'})

song_names = []

for table in tables:
    rows = table.findAll('tr')

    for row in rows[1:]:
        cols = row.findAll('td')

        if cols and len(cols) > 1:
            song_name = cols[-2].text.strip()
            song_names.append(song_name)


stripped_songs = [song.replace('“', '').replace('”', '').replace('\'', '').replace('\"', '').strip() for song in song_names]


formatted_songs = ',\n  '.join(f'"{song}"' for song in stripped_songs)

"""Requesting audio features of these songs from Spotify"""

!pip install spotipy
import spotipy
from spotipy.oauth2 import SpotifyClientCredentials


CLIENT_ID = '32b061919ffd4e3886beaf5eae45c9eb'
CLIENT_SECRET = 'b735817bbfd54b34b8a38c68d6ff8304'

client_credentials_manager = SpotifyClientCredentials(client_id=CLIENT_ID, client_secret=CLIENT_SECRET)
sp = spotipy.Spotify(client_credentials_manager=client_credentials_manager)


audio_features_list = []


track_info = []

for song in stripped_songs:
    result = sp.search(song, limit=1)
    if result['tracks']['items']:
        track_item = result['tracks']['items'][0]
        track_id = track_item['id']
        #track_ids.append(track_id)


        track_name = track_item['name']
        artist_name = track_item['artists'][0]['name']  #this gets the primary artist
        album_name = track_item['album']['name']

        track_info.append({
            'id': track_id,
            'track_name': track_name,
            'artist_name': artist_name,
            'album_name': album_name
        })


        if len(track_info) == 5:
            ids_for_batch = [info['id'] for info in track_info]
            features_batch = sp.audio_features(ids_for_batch)
            for idx, features in enumerate(features_batch):
                features['track_name'] = track_info[idx]['track_name']
                features['artist_name'] = track_info[idx]['artist_name']
                features['album_name'] = track_info[idx]['album_name']
                audio_features_list.append(features)
            track_info = []


if track_info:
    ids_for_batch = [info['id'] for info in track_info]
    features_batch = sp.audio_features(ids_for_batch)
    for idx, features in enumerate(features_batch):
        features['track_name'] = track_info[idx]['track_name']
        features['artist_name'] = track_info[idx]['artist_name']
        features['album_name'] = track_info[idx]['album_name']
        audio_features_list.append(features)

"""Convert the results into a pandas dataframe"""

import pandas as pd


martindf = pd.DataFrame(audio_features_list)
martindf.to_csv('martindf.csv')

martindf

"""## Greg Kurstin - has features, no artist in query

Scraping songs from wiki: https://en.wikipedia.org/wiki/Greg_Kurstin_production_discography
"""

url = "https://en.wikipedia.org/wiki/Greg_Kurstin_production_discography"


response = requests.get(url)
soup = BeautifulSoup(response.content, 'html.parser')
stop_headline = soup.find('span', {'class': 'mw-headline', 'id': 'Songs_written_and_produced_as_part_of_an_ensemble'})
all_tables = soup.findAll('table', {'class': 'wikitable'})
tables = [table for table in all_tables if table.find_previous('span', {'class': 'mw-headline'}) != stop_headline]
song_names = []


for table in tables:
    caption = table.find('caption')
    if caption and "Songs written and produced as part of an ensemble" in caption.get_text():
        break

    rows = table.findAll('tr')
    for row in rows[1:]:
        song_cell = row.find('th', {'scope': 'row'})
        if song_cell:
            song_name = song_cell.text.strip()
            song_names.append(song_name)
kurstin_stripped_songs = [song.replace('“', '').replace('”', '').replace('\'', '').replace('\"', '').strip() for song in song_names]
kurstin_formatted_songs = ',\n  '.join(f'"{song}"' for song in kurstin_stripped_songs)
print(f'[{kurstin_formatted_songs}]')

CLIENT_ID = '49988deb9dfd4dfe9056dbea1598971f'
CLIENT_SECRET = '230167a823f14c2daf4abfe194b508cf'

client_credentials_manager = SpotifyClientCredentials(client_id=CLIENT_ID, client_secret=CLIENT_SECRET)
sp = spotipy.Spotify(client_credentials_manager=client_credentials_manager)



kurstin_selected_features_list = []

key_map = {
    0: 'C', 1: 'C♯, D♭', 2: 'D', 3: 'D♯, E♭', 4: 'E', 5: 'F', 6: 'F♯, G♭', 7: 'G',
    8: 'G♯, A♭', 9: 'A', 10: 'A♯, B♭', 11: 'B'
}
mode_map = {
    0: 'Minor',
    1: 'Major'
}

track_data = []
track_ids = []

for song in kurstin_stripped_songs:
    time.sleep(0.5)
    result = sp.search(song, limit=1)
    if result['tracks']['items']:
        track_item = result['tracks']['items'][0]
        track_id = track_item['id']
        track_ids.append(track_id)
        track_data.append({
            'track_name': track_item['name'],
            'artist_name': track_item['artists'][0]['name'],
            'album_name': track_item['album']['name'],
            'artist_id': track_item['artists'][0]['id'],
            'album_id': track_item['album']['id']
        })

        # if we've collected 5 track IDs, fetch their audio features and clear the list for the next batch
        if len(track_ids) == 5:
            features_batch = sp.audio_features(track_ids)
            for idx, features in enumerate(features_batch):
                # map key and mode to their string names
                features['key_name'] = key_map.get(features['key'])
                features['mode_name'] = mode_map.get(features['mode'])
                features['key_mode'] = f"{features['key_name']} {features['mode_name']}"

                # combine basic details with fetched audio features
                combined_features = {**track_data[idx], **features}
                kurstin_selected_features_list.append(combined_features)

            track_ids = []
            track_data = []

# handle any remaining songs that didn't form a complete batch of 5
if track_ids:
    features_batch = sp.audio_features(track_ids)
    for idx, features in enumerate(features_batch):
        features['key_name'] = key_map.get(features['key'])
        features['mode_name'] = mode_map.get(features['mode'])
        features['key_mode'] = f"{features['key_name']} {features['mode_name']}"
        combined_features = {**track_data[idx], **features}
        kurstin_selected_features_list.append(combined_features)

kurstindf = pd.DataFrame(kurstin_selected_features_list)

kurstindf.to_csv('kurstindf.csv')

kurstindf

"""## Paul Epworth - no artist in query


Scraped from wiki: https://en.wikipedia.org/wiki/Paul_Epworth#Discography

"""

url = "https://en.wikipedia.org/wiki/Paul_Epworth#Discography"


response = requests.get(url)
soup = BeautifulSoup(response.content, 'html.parser')
tables = soup.findAll('table', {'class': 'wikitable'})
song_names = []


for table in tables:
    rows = table.findAll('tr')

    for row in rows[1:]:
        song_cell = row.find('th', {'scope': 'row'})
        if song_cell:
            song_name = song_cell.text.strip()
            song_names.append(song_name)

stripped_songs = [song.replace('“', '').replace('”', '').replace('\'', '').replace('\"', '').strip() for song in song_names]

formatted_songs = ',\n  '.join(f'"{song}"' for song in stripped_songs)

audio_features_list = []


track_info = []

for song in stripped_songs:
    result = sp.search(song, limit=1)
    if result['tracks']['items']:
        track_item = result['tracks']['items'][0]
        track_id = track_item['id']
        #track_ids.append(track_id)

        track_name = track_item['name']
        artist_name = track_item['artists'][0]['name']
        album_name = track_item['album']['name']

        track_info.append({
            'id': track_id,
            'track_name': track_name,
            'artist_name': artist_name,
            'album_name': album_name
        })

        if len(track_info) == 5:
            ids_for_batch = [info['id'] for info in track_info]
            features_batch = sp.audio_features(ids_for_batch)
            for idx, features in enumerate(features_batch):
                features['track_name'] = track_info[idx]['track_name']
                features['artist_name'] = track_info[idx]['artist_name']
                features['album_name'] = track_info[idx]['album_name']
                audio_features_list.append(features)
            track_info = []

if track_info:
    ids_for_batch = [info['id'] for info in track_info]
    features_batch = sp.audio_features(ids_for_batch)
    for idx, features in enumerate(features_batch):
        features['track_name'] = track_info[idx]['track_name']
        features['artist_name'] = track_info[idx]['artist_name']
        features['album_name'] = track_info[idx]['album_name']
        audio_features_list.append(features)

epworthdf = pd.DataFrame(audio_features_list)
epworthdf.to_csv('epworthdf.csv')

epworthdf

"""## Mark Ronson -prod creds not straightforward

** production credits aren't as straightforward to gather/scrape?

## Joel Little - has artist, accurate

Scraped the wiki: https://en.wikipedia.org/wiki/Joel_Little#Production_and_writing_credits


edits:
- Because this wiki had quirks in the scraping process, the search query searches for either the track and the artist or the track and the album. This is to prevent scraping from the wrong artists.
"""

import requests
from bs4 import BeautifulSoup

url = "https://en.wikipedia.org/wiki/Joel_Little#Production_and_writing_credits"
response = requests.get(url)
soup = BeautifulSoup(response.content, 'html.parser')

table = soup.find('table', class_='wikitable')

tracks_with_artists_or_albums = []

if table:
    rows = table.findAll('tr')
    headers = [header.text.strip() for header in rows[0].findAll('th')]

    song_col_index, artist_col_index, album_col_index = None, None, None
    if 'Song' in headers:
        song_col_index = headers.index('Song')
    if 'Artist' in headers:
        artist_col_index = headers.index('Artist')
    if 'Album' in headers:
        album_col_index = headers.index('Album')

    adjusted_indices = [0 for _ in rows]
    current_artist_or_album = None

    for i, row in enumerate(rows[1:]):
        cells = row.findAll('td')
        for j, cell in enumerate(cells):
            if 'rowspan' in cell.attrs:
                rowspan_value = int(cell['rowspan'])
                if j == artist_col_index:
                    current_artist_or_album = cell.text.strip()
                for k in range(1, rowspan_value):
                    adjusted_indices[i + k] += 1

        song_index = song_col_index - adjusted_indices[i]
        artist_or_album_index = artist_col_index - adjusted_indices[i]

        song_name, artist_or_album_name = None, None
        if 0 <= song_index < len(cells):
            song_name = cells[song_index].text.strip().strip('"')

        if 0 <= artist_or_album_index < len(cells):
            artist_or_album_name = cells[artist_or_album_index].text.strip()
        else:
            artist_or_album_name = current_artist_or_album

        if song_name and song_name != "✓":
            tracks_with_artists_or_albums.append(f'"{song_name} {artist_or_album_name}"')


for track_artist_or_album in tracks_with_artists_or_albums:
    print(track_artist_or_album)

audio_features_list = []

track_info = []

for song in tracks_with_artists_or_albums:

    result = sp.search(song, limit=1)
    if result['tracks']['items']:
        track_item = result['tracks']['items'][0]
        track_id = track_item['id']


        track_name = track_item['name']
        artist_name = track_item['artists'][0]['name']
        album_name = track_item['album']['name']


        track_info.append({
            'id': track_id,
            'track_name': track_name,
            'artist_name': artist_name,
            'album_name': album_name
        })


        if len(track_info) == 5:
            ids_for_batch = [info['id'] for info in track_info]
            features_batch = sp.audio_features(ids_for_batch)

            for idx, features in enumerate(features_batch):
                features['track_name'] = track_info[idx]['track_name']
                features['artist_name'] = track_info[idx]['artist_name']
                features['album_name'] = track_info[idx]['album_name']
                audio_features_list.append(features)

            track_info = []

if track_info:
    ids_for_batch = [info['id'] for info in track_info]
    features_batch = sp.audio_features(ids_for_batch)

    for idx, features in enumerate(features_batch):
        features['track_name'] = track_info[idx]['track_name']
        features['artist_name'] = track_info[idx]['artist_name']
        features['album_name'] = track_info[idx]['album_name']
        audio_features_list.append(features)

littledf = pd.DataFrame(audio_features_list)
littledf.to_csv('littledf.csv')

littledf

"""## Ariel Rechtshaid - has artist, accurate

Scraped wiki: https://en.wikipedia.org/wiki/Ariel_Rechtshaid

This one is somewhat incomplete because the table doesn't have the full track lists for each album, and the individual wikis for each album link are too varied to scrape efficiently. I've scraped only the featured songs.

issues:
- getting the wrong songs because tracks have the same name (i.e. Stay Away - Nirvana)
"""

import requests
from bs4 import BeautifulSoup

url = "https://en.wikipedia.org/wiki/Ariel_Rechtshaid"

response = requests.get(url)
soup = BeautifulSoup(response.content, 'html.parser')
tables = soup.findAll('table', {'class': 'wikitable'})

song_artist_pairs = []


for table in tables:

    rows = table.findAll('tr')

    rowspan_offset = 0

    for row in rows[1:]:
        cols = row.findAll('td')

        if rowspan_offset:
            artist_index = 0
            album_or_song_index = 1
            rowspan_offset -= 1
        else:
            artist_index = 1
            album_or_song_index = 2

        artist_name = cols[artist_index].text.strip()

        if cols and 'rowspan' in cols[0].attrs:
            rowspan_offset = int(cols[0]['rowspan']) - 1

        if cols and len(cols) > album_or_song_index:
            album_or_song_text = cols[album_or_song_index].text.strip()
            if "–" in album_or_song_text:
                songs_after_dash = album_or_song_text.split("–")[1].strip()
                song_list = [song.strip() for song in songs_after_dash.split(",")]

                for song in song_list:
                    song_artist_pairs.append((artist_name, song))

stripped_pairs = [(pair[0], pair[1].replace('“', '').replace('”', '').replace('\'', '').replace('\"', '').strip()) for pair in song_artist_pairs]
inverted_pairs = [(track.strip(), artist.strip()) for artist, track in stripped_pairs]
inverted_pairs = [song + " " + artist for song, artist in inverted_pairs]
inverted_pairs

audio_features_list = []
track_info = []

for song in inverted_pairs:
    result = sp.search(song, limit=1)
    if result['tracks']['items']:
        track_item = result['tracks']['items'][0]
        track_id = track_item['id']
        track_name = track_item['name']
        artist_name = track_item['artists'][0]['name']
        album_name = track_item['album']['name']
        track_info.append({
            'id': track_id,
            'track_name': track_name,
            'artist_name': artist_name,
            'album_name': album_name
        })

        if len(track_info) == 5:
            ids_for_batch = [info['id'] for info in track_info]
            features_batch = sp.audio_features(ids_for_batch)

            for idx, features in enumerate(features_batch):
                features['track_name'] = track_info[idx]['track_name']
                features['artist_name'] = track_info[idx]['artist_name']
                features['album_name'] = track_info[idx]['album_name']
                audio_features_list.append(features)

            track_info = []

if track_info:
    ids_for_batch = [info['id'] for info in track_info]
    features_batch = sp.audio_features(ids_for_batch)

    for idx, features in enumerate(features_batch):
        features['track_name'] = track_info[idx]['track_name']
        features['artist_name'] = track_info[idx]['artist_name']
        features['album_name'] = track_info[idx]['album_name']
        audio_features_list.append(features)

rechtdf = pd.DataFrame(audio_features_list)
rechtdf.to_csv('rechtdf.csv')

rechtdf

"""## Recommended Songs

"""

import requests
import base64
import time
import csv

client_id = '49988deb9dfd4dfe9056dbea1598971f'
client_secret = '230167a823f14c2daf4abfe194b508cf'

def get_track_ids_from_csv(filename):
    with open(filename, 'r', encoding='utf-8') as csv_file:
        reader = csv.DictReader(csv_file)
        return [row['track_id'] for row in reader if row['jack'] == '1']

songs_dataset = get_track_ids_from_csv('df.csv')

def get_access_token(client_id, client_secret):
    auth_url = 'https://accounts.spotify.com/api/token'
    client_creds = f"{client_id}:{client_secret}"
    client_creds_b64 = base64.b64encode(client_creds.encode())
    headers = {
        "Authorization": f"Basic {client_creds_b64.decode()}"
    }
    payload = {
        'grant_type': 'client_credentials'
    }
    r = requests.post(auth_url, headers=headers, data=payload)
    token = r.json().get("access_token")
    return token

def get_recommendations(track_ids, token):
    recommendations_url = f"https://api.spotify.com/v1/recommendations?seed_tracks={','.join(track_ids)}"
    headers = {
        "Authorization": f"Bearer {token}"
    }
    r = requests.get(recommendations_url, headers=headers)
    retry_count = 0

    while r.status_code == 429 and retry_count < 3:
        retry_after = int(r.headers.get("Retry-After", 1))
        print(f"Rate limited. Waiting for {retry_after} seconds.")
        time.sleep(retry_after)
        r = requests.get(recommendations_url, headers=headers)
        retry_count += 1

    return r.json().get('tracks', [])

token = get_access_token(client_id, client_secret)

track_recommendations = {}

#make recs in batches of 5 to manage rate limiting
for i in range(0, len(songs_dataset), 5):
    batch = songs_dataset[i:i+5]
    related_songs = get_recommendations(batch, token)

    for track_id, song in zip(batch, related_songs):
        if song:
            track_recommendations[track_id] = song

"""Save recommend_tracks to csv"""

track_recommendations

len(track_recommendations)

import csv
with open('recommended_tracks.csv', 'w', newline='', encoding='utf-8') as csv_file:
    writer = csv.writer(csv_file)
    header = [
        "Track ID",
        "Track Name",
        "Main Artist",
        "Main Artist ID",
        "Album Name",
        "Album ID",
        "Album Type",
        "Release Date",
        "Track Duration (ms)",
        "Track Popularity",
        "Track Number",
        "Spotify Track URL",
        "Spotify Artist URL",
        "Spotify Album URL",
        "Preview URL"
    ]
    writer.writerow(header)
    for track_id, track_data in track_recommendations.items():
        track_name = track_data['name']
        main_artist = track_data['artists'][0]['name']
        main_artist_id = track_data['artists'][0]['id']
        album_name = track_data['album']['name']
        album_id = track_data['album']['id']
        album_type = track_data['album']['album_type']
        release_date = track_data['album']['release_date']
        duration = track_data['duration_ms']
        popularity = track_data['popularity']
        track_number = track_data['track_number']
        spotify_track_url = track_data['external_urls']['spotify']
        spotify_artist_url = track_data['artists'][0]['external_urls']['spotify']
        spotify_album_url = track_data['album']['external_urls']['spotify']
        preview_url = track_data['preview_url']

        row_data = [
            track_id,
            track_name,
            main_artist,
            main_artist_id,
            album_name,
            album_id,
            album_type,
            release_date,
            duration,
            popularity,
            track_number,
            spotify_track_url,
            spotify_artist_url,
            spotify_album_url,
            preview_url
        ]
        writer.writerow(row_data)

"""Seeing how many recommended songs are produced by jack (match the names of songs in our list of Jack-produced songs)"""



import csv

def get_track_names_from_csv(filename):
    track_names = []
    with open(filename, 'r', encoding='utf-8') as csv_file:
        reader = csv.DictReader(csv_file)
        for row in reader:
            track_names.append(row['track_name'])
    return track_names

df_track_names = get_track_names_from_csv('df.csv')
song_rec_track_names = [track_data['name'] for track_data in track_recommendations.values()]


matching_tracks = set(df_track_names).intersection(song_rec_track_names)
if matching_tracks:
    print("Matching track names:")
    for track_name in matching_tracks:
        print(track_name)
else:
    print("No matching track names found.")

len(matching_tracks)

"""Getting the audio features for songs in the recommended songs list"""

import requests
import csv

def get_audio_features(track_ids, token):
    base_url = "https://api.spotify.com/v1/audio-features"
    headers = {
        "Authorization": f"Bearer {token}"
    }
    features_list = []




token = get_access_token(client_id, client_secret)

track_ids = list(track_recommendations.keys())
track_names = [track_recommendations[id]['name'] for id in track_ids]
artists = [track_recommendations[id]['artists'][0]['name'] for id in track_ids]

audio_features_rec = get_audio_features(track_ids, token)

with open('audio_features_rec.csv', 'w', newline='', encoding='utf-8') as csv_file:
    writer = csv.writer(csv_file)
    header = ["Track ID", "Track Name", "Artist", "Danceability", "Energy", "Key", "Loudness", "Mode", "Speechiness", "Acousticness", "Instrumentalness", "Liveness", "Valence", "Tempo", "Type", "ID", "URI", "Track Href", "Analysis URL", "Duration Ms", "Time Signature"]
    writer.writerow(header)

    for i, feature in enumerate(audio_features_rec):
        if feature:
            row = [track_ids[i], track_names[i], artists[i], feature["danceability"], feature["energy"], feature["key"], feature["loudness"], feature["mode"], feature["speechiness"], feature["acousticness"], feature["instrumentalness"], feature["liveness"], feature["valence"], feature["tempo"], feature["type"], feature["id"], feature["uri"], feature["track_href"], feature["analysis_url"], feature["duration_ms"], feature["time_signature"]]
            writer.writerow(row)

audio_features_rec

"""Do they have the same columns?"""

import pandas as pd


audio_features_rec = pd.read_csv('audio_features_rec.csv')
df = pd.read_csv('df.csv')

audio_features_rec_columns = set(audio_features_rec.columns)
df_columns = set(df.columns)

if audio_features_rec_columns == df_columns:
    print("Both DataFrames have the same columns.")
else:
    print("DataFrames have different columns.")


    missing_in_df = audio_features_rec_columns.difference(df_columns)
    if missing_in_df:
        print("Columns in audio_features_rec but not in df:", ", ".join(missing_in_df))

    missing_in_audio_features_rec = df_columns.difference(audio_features_rec_columns)
    if missing_in_audio_features_rec:
        print("Columns in df but not in audio_features_rec:", ", ".join(missing_in_audio_features_rec))

""" Make it so that the column title formats are the same

"""

audio_features_rec = audio_features_rec.rename(columns={
    'Track Name': 'track_name',
    'Loudness': 'loudness',
    'Duration Ms': 'duration_ms',
    'Track ID': 'track_id',
    'ID': 'id',
    'Speechiness': 'speechiness',
    'Analysis URL': 'analysis_url',
    'Valence': 'valence',
    'Time Signature': 'time_signature',
    'URI': 'track_uri',
    'Tempo': 'tempo',
    'Artist': 'artist_name',
    'Type': 'type',
    'Energy': 'energy',
    'Track Href': 'track_href',
    'Mode': 'mode',
    'Liveness': 'liveness',
    'Instrumentalness': 'instrumentalness',
    'Key': 'key',
    'Danceability': 'danceability',
    'Acousticness': 'acousticness'
})



"""## Adding them all together into one big DF - done except for recommended

In each df, make a column called "producer". slice the last two letters off of each df name, and make the remaining name the value entry for the row.
"""

dfs = [epworthdf, kurstindf, littledf, martindf, rechtdf]

df_names = ['epworth', 'kurstin', 'little', 'martin', 'rechtshaid']

for df, name in zip(dfs, df_names):
    df['producer'] = name

final_df = pd.concat(dfs, ignore_index=True)

final_df.to_csv('oct26result.csv', index=False)

updatedjack = pd.read_csv('updated_jack_oct26.csv')

dfs = [final_df, updatedjack]

oct26finaldf = pd.concat(dfs, ignore_index=True)

oct26finaldf.to_csv('oct26finaldf.csv', index=False)

result_df.to_csv('result.csv', index=False)



"""## Removing duplicates

edit: they're not actually duplicates. they're being overwritten


"""



import pandas as pd

df = pd.read_csv('workingonthisone_result.csv')

len(df)

df_dropped = df.drop_duplicates(keep = 'first')

df_dropped

df_dropped.to_csv('dropped_df.csv', index=False)
