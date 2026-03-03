package com.sena.test.IRepository.IBillRepository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sena.test.Entity.Bill.BillDetail;
import java.util.List;

public interface IRepositoryBillDetail extends JpaRepository<BillDetail, Long> {

    List<BillDetail> findByBillId(Long billId);
}