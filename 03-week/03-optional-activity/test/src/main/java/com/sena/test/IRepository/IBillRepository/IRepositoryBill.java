package com.sena.test.IRepository.IBillRepository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sena.test.Entity.Bill.Bill;

public interface IRepositoryBill extends JpaRepository<Bill, Long> {
}
