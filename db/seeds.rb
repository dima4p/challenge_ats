Job.transaction do
  job1 = Job.create_with(description: 'Description of the Job 1')
          .find_or_create_by title: 'Front-end developer'
  job2 = Job.create_with(description: 'Description of the Job 2')
          .find_or_create_by title: 'Back-end developer'
  job3 = Job.create_with(description: 'Description of the Job 3')
          .find_or_create_by title: 'Full stack developer'
  job4 = Job.create_with(description: 'Description of the Job 4')
          .find_or_create_by title: 'ML developer'

  application11 = Application.find_or_create_by candidate_name: 'Mark Zuckerberg',
      job_id: job1.id
  application21 = Application.find_or_create_by candidate_name: 'Bill Gates',
      job_id: job2.id
  application31 = Application.find_or_create_by candidate_name: 'Sergey Brin',
      job_id: job3.id
  application32 = Application.find_or_create_by candidate_name: 'Dmitry Kulikov',
      job_id: job3.id
  application41 = Application.find_or_create_by candidate_name: 'Faisan Khan',
      job_id: job4.id
  application42 = Application.find_or_create_by candidate_name: 'Dmitry Kulikov',
      job_id: job4.id

  Application::Event::Note.create_with(content: 'Frontend is too buggy')
         .find_or_create_by object: application11

  Job::Event::Activated.find_or_create_by object: job2
  Application::Event::Interview.create_with(date: 2.weeks.ago)
         .find_or_create_by object: application21
  Application::Event::Note.create_with(content: 'No iedea how to make programs')
         .find_or_create_by object: application21
  Application::Event::Rejected.find_or_create_by object: application21
  Job::Event::Deactivated.find_or_create_by object: job2

  Job::Event::Activated.find_or_create_by object: job3
  Application::Event::Interview.create_with(date: 3.weeks.ago)
         .find_or_create_by object: application31

  Application::Event::Hired.find_or_create_by object: application32
  Application::Event::Interview.create_with(date: 3.days.ago)
         .find_or_create_by object: application32
  Application::Event::Note.create_with(content: 'Perfect job!')
         .find_or_create_by object: application32
  Application::Event::Hired.find_or_create_by object: application32

  Job::Event::Activated.find_or_create_by object: job4
  Application::Event::Interview.create_with(date: 4.weeks.ago)
         .find_or_create_by object: application42

  Application::Event::Interview.create_with(date: 5.weeks.ago)
         .find_or_create_by object: application41
  Application::Event::Note.create_with(content: 'Deep knowledge')
         .find_or_create_by object: application41
  Application::Event::Hired.find_or_create_by object: application41
end
