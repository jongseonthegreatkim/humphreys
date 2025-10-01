import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:humphreys/station.dart';
import 'package:humphreys/widgets.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // 즐겨찾기된 정류장 목록 (임시 데이터)
  List<Map<String, dynamic>> _favorites = [
    {
      'station': Station(
        stationName: 'Main Exchange',
        stationPosition: const LatLng(36.965583, 126.998128),
      ),
      'route': 'Blue',
      'color': const Color(0xFF0029FF),
      'addedDate': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'station': Station(
        stationName: 'Commissary',
        stationPosition: const LatLng(36.963948, 127.003098),
      ),
      'route': 'Green',
      'color': const Color(0xFF4CA546),
      'addedDate': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'station': Station(
        stationName: 'Spartan DFAC',
        stationPosition: const LatLng(36.970343, 127.008175),
      ),
      'route': 'Blue',
      'color': const Color(0xFF0029FF),
      'addedDate': DateTime.now().subtract(const Duration(hours: 6)),
    },
  ];

  void _removeFavorite(int index) {
    setState(() {
      _favorites.removeAt(index);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Removed from favorites'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _addToFavorites(Station station, String route, Color color) {
    // 이미 즐겨찾기에 있는지 확인
    final exists = _favorites.any((fav) => 
        fav['station'].stationName == station.stationName);
    
    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Already in favorites'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _favorites.add({
        'station': station,
        'route': route,
        'color': color,
        'addedDate': DateTime.now(),
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to favorites'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Widgets.humphreysRed,
        elevation: 0,
        actions: [
          if (_favorites.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear All Favorites'),
                    content: const Text(
                      'Are you sure you want to remove all favorites?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _favorites.clear();
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('All favorites cleared'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                        child: const Text(
                          'Clear All',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: _favorites.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Add stations to your favorites',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    '💡 Tip: Tap the heart icon on any station\nto add it to favorites',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                final favorite = _favorites[index];
                final station = favorite['station'] as Station;
                final route = favorite['route'] as String;
                final color = favorite['color'] as Color;
                final addedDate = favorite['addedDate'] as DateTime;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color.withOpacity(0.2),
                      child: Text(
                        route[0],
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      station.stationName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$route Route',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Added ${_formatDate(addedDate)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.location_on),
                          onPressed: () {
                            // TODO: 지도에서 해당 정류장으로 이동
                            print('Go to favorite station: ${station.stationName}');
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _removeFavorite(index),
                        ),
                      ],
                    ),
                    onTap: () {
                      // TODO: 정류장 상세 정보 표시
                      print('Favorite station details: ${station.stationName}');
                    },
                  ),
                );
              },
            ),
    );
  }
}
