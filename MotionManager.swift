import CoreMotion

final class MotionManager {

    private let motionManager = CMMotionManager()
    private(set) var yawDegrees: Double = 0.0

    func start() {
        guard motionManager.isDeviceMotionAvailable else { return }

        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
        motionManager.startDeviceMotionUpdates(
            using: .xArbitraryZVertical,
            to: .main
        ) { [weak self] motion, _ in
            guard let attitude = motion?.attitude else { return }
            self?.yawDegrees = attitude.yaw * 180.0 / .pi
        }
    }

    func stop() {
        motionManager.stopDeviceMotionUpdates()
    }
}
