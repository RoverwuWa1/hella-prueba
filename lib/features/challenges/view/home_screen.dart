import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/services/auth_services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final AuthService authService = AuthService();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              // ── Header ───────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hola,',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user?.displayName?.split(' ').first ?? 'Usuario',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),

                  // Avatar
                  GestureDetector(
                    onTap: () => _showProfileSheet(context, user, authService),
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: const Color(0xFF4285F4),
                      backgroundImage: user?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : null,
                      child: user?.photoURL == null
                          ? Text(
                              (user?.displayName?.isNotEmpty == true)
                                  ? user!.displayName![0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            )
                          : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // ── Tarjeta de perfil ─────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mi cuenta',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _InfoRow(
                      icon: Icons.person_outline_rounded,
                      label: 'Nombre',
                      value: user?.displayName ?? 'Sin nombre',
                    ),
                    const Divider(height: 24, color: Color(0xFFF0F0F0)),
                    _InfoRow(
                      icon: Icons.email_outlined,
                      label: 'Correo',
                      value: user?.email ?? 'Sin correo',
                    ),
                    const Divider(height: 24, color: Color(0xFFF0F0F0)),
                    _InfoRow(
                      icon: Icons.verified_outlined,
                      label: 'Proveedor',
                      value: 'Google',
                      valueColor: const Color(0xFF4285F4),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // ── Botón cerrar sesión ───────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () => _confirmSignOut(context, authService),
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: const Text(
                    'Cerrar sesión',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE53935),
                    side: const BorderSide(color: Color(0xFFFFCDD2)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ── Bottom sheet de perfil ──────────────────────────────────────────────
  void _showProfileSheet(
      BuildContext context, User? user, AuthService authService) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: const Color(0xFF4285F4),
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : null,
              child: user?.photoURL == null
                  ? Text(
                      user?.displayName?[0].toUpperCase() ?? 'U',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600),
                    )
                  : null,
            ),
            const SizedBox(height: 12),
            Text(
              user?.displayName ?? 'Usuario',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _confirmSignOut(context, authService);
                },
                icon: const Icon(Icons.logout_rounded,
                    color: Color(0xFFE53935), size: 18),
                label: const Text(
                  'Cerrar sesión',
                  style: TextStyle(color: Color(0xFFE53935)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Confirmación de cierre de sesión ────────────────────────────────────
  void _confirmSignOut(BuildContext context, AuthService authService) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Cerrar sesión',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text('¿Estás seguro que deseas salir?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar',
                style: TextStyle(color: Color(0xFF6B7280))),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await authService.signOut();
              // AuthGate redirige automáticamente a LoginScreen
            },
            child: const Text(
              'Salir',
              style: TextStyle(
                color: Color(0xFFE53935),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widget reutilizable de fila de info ─────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF9CA3AF)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF9CA3AF),
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: valueColor ?? const Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
      ],
    );
  }
}