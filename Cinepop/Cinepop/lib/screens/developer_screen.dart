import 'package:flutter/material.dart';

import '../config/constants.dart';
import '../themes/colors.dart';
import '../widgets/app_logo.dart';

class DeveloperScreen extends StatelessWidget {
  const DeveloperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Desarrollador')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            // Avatar with the developer's initials.
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: AppColors.popRed,
                child: Text(
                  _initials(AppConstants.developerName),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppConstants.developerName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),

            // Info cards.
            _InfoTile(
              icon: Icons.school_outlined,
              label: 'Materia',
              value: AppConstants.developerSubject,
            ),
            _InfoTile(
              icon: Icons.account_balance_outlined,
              label: 'Universidad',
              value: AppConstants.developerUniversity,
            ),

            const SizedBox(height: 24),
            const _Heading('Acerca de la aplicación'),
            const SizedBox(height: 8),
            Text(
              AppConstants.developerDescription,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 14,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 32),
            // App logo + version footer.
            const Center(child: AppLogo(fontSize: 32)),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Versión ${AppConstants.appVersion}',
                style: const TextStyle(color: AppColors.divider, fontSize: 13),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.butterYellow),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  final String text;

  const _Heading(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.white,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
