import UIKit
import BackgroundFetchEvents

class WriterViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Stored Properties
    
    private let notificationCenter = NotificationCenter.default
    private let backgroundFetchEventProvider = Providers.backgroundFetchEventProvider
    private var backgroundFetchEvents: [BackgroundFetchEvent] = []
    private let dateFormatter = DateFormatter(dateStyle: .short, timeStyle: .long)
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        registerForNotifications()
        fetchBackgroundFetchEvents(reloadTable: false)
    }
    
    deinit {
        deregisterForNotifications()
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        tableView.dataSource = self
    }
    
    // MARK: - Notifications
    
    private func registerForNotifications() {
        notificationCenter.addObserver(
            forName: .didUpdateBackgroundFetchEvents,
            object: backgroundFetchEventProvider,
            queue: .main,
            using: { [weak self] _ in self?.fetchBackgroundFetchEvents(reloadTable: true) }
        )
    }
    
    private func deregisterForNotifications() {
        notificationCenter.removeObserver(self)
    }
    
    // MARK: - Fetching
    
    private func fetchBackgroundFetchEvents(reloadTable: Bool) {
        backgroundFetchEvents = backgroundFetchEventProvider.backgroundFetchEvents
            .sorted(by: { $0.occuredAt > $1.occuredAt })
        
        if reloadTable { tableView.reloadData() }
    }
    
    // MARK: - Actions
    
    @IBAction func reloadTapped(_ sender: Any) {
        fetchBackgroundFetchEvents(reloadTable: true)
    }
}

// MARK: - UITableViewDataSource

extension WriterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return backgroundFetchEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let backgroundFetchEvent = backgroundFetchEvents[indexPath.row]
        cell.textLabel?.text = dateFormatter.string(from: backgroundFetchEvent.occuredAt)
        cell.detailTextLabel?.text = backgroundFetchEvent.returnedResult.description
        
        return cell
    }
}
