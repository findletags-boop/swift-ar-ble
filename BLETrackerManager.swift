import CoreBluetooth

final class BLETrackerManager: NSObject {

    private var central: CBCentralManager!
    private(set) var latestRSSI: Int?

    override init() {
        super.init()
        central = CBCentralManager(delegate: self, queue: .main)
    }
}

extension BLETrackerManager: CBCentralManagerDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            central.scanForPeripherals(
                withServices: nil,
                options: [CBCentralManagerScanOptionAllowDuplicatesKey: true]
            )
        }
    }

    func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String : Any],
        rssi RSSI: NSNumber
    ) {
        guard let name = peripheral.name,
              name == "TRACKER_P0" else { return }

        latestRSSI = RSSI.intValue
    }
}
