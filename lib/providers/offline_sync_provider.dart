import 'package:flutter_riverpod/flutter_riverpod.dart';

class OfflineSyncState {
  final bool isOnline;
  final int pendingSyncCount;
  final bool isSyncing;
  final DateTime? lastSyncTime;

  const OfflineSyncState({
    this.isOnline = true,
    this.pendingSyncCount = 0,
    this.isSyncing = false,
    this.lastSyncTime,
  });

  OfflineSyncState copyWith({
    bool? isOnline,
    int? pendingSyncCount,
    bool? isSyncing,
    DateTime? lastSyncTime,
  }) {
    return OfflineSyncState(
      isOnline: isOnline ?? this.isOnline,
      pendingSyncCount: pendingSyncCount ?? this.pendingSyncCount,
      isSyncing: isSyncing ?? this.isSyncing,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }
}

class OfflineSyncNotifier extends StateNotifier<OfflineSyncState> {
  OfflineSyncNotifier() : super(OfflineSyncState(lastSyncTime: DateTime.now()));

  void toggleNetwork(bool online) {
    if (!online) {
      state = state.copyWith(isOnline: false, pendingSyncCount: state.pendingSyncCount + 2);
    } else {
      state = state.copyWith(isOnline: true);
      triggerSync();
    }
  }

  void addPendingRecord() {
    if (!state.isOnline) {
      state = state.copyWith(pendingSyncCount: state.pendingSyncCount + 1);
    }
  }

  Future<void> triggerSync() async {
    if (state.pendingSyncCount == 0) return;
    state = state.copyWith(isSyncing: true);
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(
      isSyncing: false,
      pendingSyncCount: 0,
      lastSyncTime: DateTime.now(),
    );
  }
}

final offlineSyncProvider = StateNotifierProvider<OfflineSyncNotifier, OfflineSyncState>((ref) {
  return OfflineSyncNotifier();
});
