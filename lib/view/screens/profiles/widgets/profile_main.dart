import 'package:flutter/material.dart';
import 'package:mediafarnetcc/view/core/theme/app_colors.dart';

class ProfileMain extends StatelessWidget {
  const ProfileMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [

          // ---- AVATAR + NOME ----
          Row(
            children: [
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.black,
                child: const Icon(Icons.person, color: Colors.white, size: 45),
              ),

              const SizedBox(width: 16),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Lucas Farnese',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '@Farnesinho',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ---- DIVISOR ----
          const Divider(height: 1, color: AppColors.dark),

          const SizedBox(height: 16),

          // ---- STATS: POSTS | SEGUIDORES | SEGUINDO ----
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _status('42', 'Posts'),
              _status('1,2K', 'Seguidores'),
              _status('180', 'Seguindo'),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.dark),
          const SizedBox(height: 12),

          // ---- INFORMAÇÕES ----
          _informacoes(Icons.cake,           'Nascimento: 15/03/1998'),
          _informacoes(Icons.calendar_today, 'Membro desde: Jan 2023'),


        ],
      ),
    );
  }

  Widget _status(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _informacoes(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}