import 'package:flutter/material.dart';
import '../routes/app_tab.dart';



class LeftMenu extends StatelessWidget {
  final AppTab selected;
  final ValueChanged<AppTab> onSelect;

  const LeftMenu({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF8B0000); // rojo fallero
    const card = Color(0xFFB30000);
    const active = Color(0xFF0B4DB3); // azul (como franja de cards)
    const yellow = Color(0xFFF7D96B);

    return Container(
      width: 210,
      color: bg,
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header (tipo mockup)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(18),
              border:
                  Border.all(color: Colors.white.withOpacity(0.15), width: 2),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: yellow,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.local_fire_department,
                      color: bg, size: 28),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Cor Falles',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Items
          _MenuItem(
            icon: Icons.home_rounded,
            label: 'Inicio',
            isActive: selected == AppTab.inicio,
            activeColor: active,
            onTap: () => onSelect(AppTab.inicio),
          ),
          const SizedBox(height: 10),
          _MenuItem(
            icon: Icons.event_rounded,
            label: 'Eventos',
            isActive: selected == AppTab.eventos,
            activeColor: active,
            onTap: () => onSelect(AppTab.eventos),
          ),
          const SizedBox(height: 10),
          _MenuItem(
            icon: Icons.map_rounded,
            label: 'Mapa',
            isActive: selected == AppTab.mapa,
            activeColor: active,
            onTap: () => onSelect(AppTab.mapa),
          ),
          const SizedBox(height: 10),
          _MenuItem(
            icon: Icons.settings_rounded,
            label: 'Ajustes',
            isActive: selected == AppTab.ajustes,
            activeColor: active,
            onTap: () => onSelect(AppTab.ajustes),
          ),

          const Spacer(),

          // Footer
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: Colors.white.withOpacity(0.12), width: 2),
            ),
            child: const Text(
              'Valencia · Fallas',
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white70, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isActive ? activeColor : Colors.white.withOpacity(0.12);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isActive
                  ? Colors.white.withOpacity(0.22)
                  : Colors.white.withOpacity(0.10),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
