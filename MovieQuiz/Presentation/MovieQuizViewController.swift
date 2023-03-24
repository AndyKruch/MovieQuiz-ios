import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBAction func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction func nobuttonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var questionLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    private var correctAnswers: Int = 0
    
    private var currentQuestionIndex: Int = 0
    private var currentQuestion: QuizQuestion?
    private let questionsAmount: Int = 10
    
    private var questionFactory: QuestionFactoryProtocol?
    
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticServiceProtocol?
    
// MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenterImpl(viewController: self)
        statisticService = StatisticServiceImpl()
    }
    
    // MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showFinalResult() {
        
        statisticService?.store(correct: correctAnswers, total: questionsAmount)
        
        
        let alertModel = AlertModel(title: "Игра окончена",
                                    message: makeResultMessage(),
                                    buttonText: "Сыграть еще раз",
                                    completion: { [weak self] in self?.currentQuestionIndex = 0
            self?.correctAnswers = 0
            self?.questionFactory?.requestNextQuestion()
        }
        )
        alertPresenter?.show(alertModel: alertModel)
    }
    
    private func makeResultMessage() -> String {
        
        guard let statisticService = statisticService, let bestGame = statisticService.bestGame else {
            assertionFailure("error!")
            return ""
        }
        
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gameCount)"
        let currentGameResultline = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)" + "(\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        
        let resultMessage = [currentGameResultline, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine].joined(separator: "\n")
        
        return resultMessage
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
                    image: UIImage(named: model.image) ?? UIImage(),
                    question: model.text,
                    questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }

    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
        showFinalResult()
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.imageView.layer.borderColor = UIColor.clear.cgColor
            
        }
    }
}
