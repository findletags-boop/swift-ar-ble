import UIKit
import ARKit
import RealityKit

final class ViewController: UIViewController {
  private var arView: ARView!
  private let scanButton = UIButton(type: .system)
  private let angleLabel = UILabel()
  private let motionManager = MotionManager()
  private let bleManager = BLETrackerManager()

  override func viewDidLoad() {
      super.viewDidLoad()
      setupARView()
      setupOverlayUI()
      startARSession()
      motionManager.start()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
        guard let self = self else { return }
        let angle = self.motionManager.yawDegrees
        self.angleLabel.text = String(format: "Angle: %.1f°", angle)
    }
  }

  private func setupARView() {
      arView = ARView(frame: view.bounds)
      arView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      view.addSubview(arView)
  }

  private func startARSession() {
      let config = ARWorldTrackingConfiguration()
      config.worldAlignment = .gravity
      arView.session.run(config)
  }

  private func setupOverlayUI() {
      angleLabel.text = "Angle: 0°"
      angleLabel.textColor = .white
      angleLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .medium)
      angleLabel.translatesAutoresizingMaskIntoConstraints = false

      scanButton.setTitle("360° Scan", for: .normal)
      scanButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
      scanButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.9)
      scanButton.tintColor = .white
      scanButton.layer.cornerRadius = 12
      scanButton.translatesAutoresizingMaskIntoConstraints = false

      view.addSubview(angleLabel)
      view.addSubview(scanButton)

      NSLayoutConstraint.activate([
          angleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
          angleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

          scanButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
          scanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
          scanButton.widthAnchor.constraint(equalToConstant: 180),
          scanButton.heightAnchor.constraint(equalToConstant: 50)
      ])
  }
}
